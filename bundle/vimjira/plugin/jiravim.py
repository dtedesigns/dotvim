import os, sys
import urllib2
from suds.client import Client
from suds import WebFault
import logging
import re

# Simple struct to collect a suds client and an auth token together.
class soap_client:
    def __init__(self, suds_client, auth_token):
        self.client = suds_client
        self.auth = auth_token

def create_err_string(msg):
    return 'echohl ErrorMsg|echomsg \'%s\'|echohl None' % msg

def handle_web_fault(fault):
    exception = ""
    try:
        # For now, the best way to figure out what exception was thrown remotely is
        # to decode the fault string.
        full_exception = re.match("((?:\w*\.)*\w*):\s*(.*)$", fault.faultstring).group(1)
        exception = re.match("(?:\w*\.)*(\w*)", full_exception).group(1)
    except Exception, e:
        print e
        pass

    if exception == "RemoteAuthenticationException":
        print "let fail_type = 'auth'"
    else:
        print "let fail_type = 'unknown'"
    print create_err_string(fault.faultstring)

def vim_quote(str):
    return str.replace("'", "''")


def create_client(url, username, password):
    client = Client(url)
    auth_token = client.service.login(username, password)
    return soap_client(client, auth_token)

def get_worklogs(client, key, worklog_vim_script_array_name):
    try:
        worklogs = client.client.service.getWorklogs(client.auth, key)
    except WebFault, e:
        handle_web_fault(e.fault)
        return []

    all_logs_vim_script = []
    try:
        for log in worklogs:
            log_vim_script = ['let log = {}']
            log_vim_script.append('let log[\'author\'] = \'%s\'' % log.author)
            log_vim_script.append('let log[\'timeSpent\'] = \'%s\'' % log.timeSpent)
            description = "No description"
            if log.comment is not None:
                description = vim_quote(str(log.comment))
            log_vim_script.append('let log[\'comment\'] = \'%s\'' % description)
            log_vim_script.append('let log[\'created\'] = \'%s\'' % log.created.date())
            log_vim_script.append('call add(%s, log)' % worklog_vim_script_array_name)
            all_logs_vim_script.extend(log_vim_script)
    except Exception, e:
        print create_err_string(e)
        return []

    return all_logs_vim_script

def get_comments(client, key, comment_array_name):
    try:
        comments = client.client.service.getComments(client.auth, key)
    except WebFault, e:
        handle_web_fault(e.fault)
        return []

    comment_script = []
    try:
        for comment in comments:
            script = ['let comment = {}']
            script.append('let comment[\'author\'] = \'%s\'' % comment.author)
            script.append('let comment[\'body\'] = \'%s\'' % vim_quote(str(comment.body)))
            script.append('let comment[\'created\'] = \'%s\'' % comment.created.date())
            script.append('call add(%s, comment)' % comment_array_name)
            comment_script.extend(script)
    except Exception, e:
        print create_err_string(e)
        return []

    return comment_script

def get_issue(client, key, fields):
    try:
        issue = client.client.service.getIssue(client.auth, key)
    except WebFault, e:
        handle_web_fault(e.fault)
        return

    field_list = eval(fields)
    result = ['let result = {}']
    for field in field_list:
        # description and summary could have single quotes in them. We have to
        # escape them properly for VIM.
        if field == 'summary':
            result.append('let result[\'summary\'] = \'%s\'' % vim_quote(issue.summary))
        
        elif field == 'description':
            result.append('let result[\'description\'] = \'%s\'' % vim_quote(issue.description))
        
        elif field == 'assignee':
            result.append('let result[\'assignee\'] = \'%s\'' % issue.assignee)
        
        elif field == 'fixVersions':
            versions = []
            for version in issue.fixVersions:
                versions.append('\'' + version.name + '\'')
            result.append('let result[\'fixVersions\'] = [%s]' % (','.join(versions)))
        
        elif field == 'worklogs':
            worklog_script = get_worklogs(client, key, 'result[\'worklogs\']')
            if len(worklog_script) > 0:
                result.append('let result[\'worklogs\'] = []')
                result.extend(worklog_script)
        
        elif field == 'comments':
            comment_script = get_comments(client, key, 'result[\'comments\']')
            if len(comment_script) > 0:
                result.append('let result[\'comments\'] = []')
                result.extend(comment_script)

        elif field == 'components':
            components = []
            for component in issue.components:
                components.append('\'' + component.name + '\'')
            result.append('let result[\'fixVersions\'] = [%s]' % (','.join(components)))

        else:
            print create_err_string('Unknown issue field \'\'%s\'\'' % field)
            result
    for line in result:
        print line
    

def connect_and_call(url, username, password, function_ref, *args):

    client = None
    try:
        client = create_client(url, username, password)
    except urllib2.URLError, e:
        print "let fail_type = 'url'"
        print create_err_string('Unable to connect to JIRA SoapService URL') 
        return
    except WebFault, e:
        handle_web_fault(e.fault)
        return
    except Exception, e:
        print "let fail_type = 'url'"
        print create_err_string(str(e))
        return

    function_ref(client, *args)

def main():
    prog = os.path.basename(sys.argv[0])

    # Turn off logging so errors don't interfere with vimscript output.
    logging.getLogger('suds.client').setLevel(logging.CRITICAL)

    # sys.argv should be structure as follows:
    # 0 - script name
    # 1 - SOAP Serive URL
    # 2 - username
    # 3 - password
    # 4 - name of function to execute
    # 5+  args passed directly to function

    if len(sys.argv) < 5:
        print create_err_string('ERROR: not enough args to %s' % prog)
        return

    function_name = sys.argv[4]
    if not globals().has_key(function_name):
        print create_err_string('ERROR: no such function %s in %s' % (function_name, prog))
        return
    if function_name == "connect_and_call":
        print create_err_string('ERROR: invalid jiravim python module call')
        return

    function_ref = globals()[function_name]
    try:
        connect_and_call(sys.argv[1], sys.argv[2], sys.argv[3], function_ref, *sys.argv[5:])
    except TypeError, e:
        print create_err_string('ERROR in %s: %s' % (prog, str(e)))

if __name__ == '__main__': main()

