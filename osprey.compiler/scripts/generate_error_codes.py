"""
generate_error_codes.py

Usage:
  generate_error_codes.py --messages=<messages> --template=<template> --output=<output>
  generate_error_codes.py --help

Options:
  --help                 Show this help screen.
  --messages=<messages>  The file that contains all the error codes and messages. The
                         message texts are ignored; only the error codes and names are
                         used.
  --template=<template>  The template file. This script replaces the placeholder text
                         '{$errorCodes$}' with the generated error code list.
  --output=<output>      The output file; that is, where the generated error code list
                         is saved.
"""

from docopt import docopt
import re

message_file_regex = re.compile(r'''
    # Comment
    (?P<comment>
        //.*
        |
        /\*[\s\S]*?\*/
    )
    |
    # Error code + message
    (?:
        # Error code value
        (?P<code>\d+(?:_\d+)*)
        \s+
        # Error code name
        (?P<name>[a-zA-Z_][a-zA-Z0-9_]*)
        \s*=\s*
        # Message - not used
        "(?:
            \\[\\"'0abnrt_\-]
            |
            \\u[0-9a-fA-F]{4}
            |
            \\U[0-9a-fA-F]{8}
            |
            [^\\"]
        )*"
        \s*;
    )
    |
    # Error character
    (?P<error>\S)
''', re.X | re.M | re.U)

output_format = '\tpublic const {name} = {code};\n'

placeholder = '{$errorCodes$}'

def read_all_text(file):
    with open(file, 'rb') as f:
        byte_data = f.read()
    return byte_data.decode('utf-8')

def write_all_text(file, text):
    byte_data = text.encode('utf-8')
    with open(file, 'wb') as f:
        f.write(byte_data)

def read_error_codes(messages):
    output = []

    for m in message_file_regex.finditer(messages):
        if m.group('comment'):
            continue
        if m.group('error'):
            error_char = ord(m.group('error'))
            raise ValueError('Invalid character: ' + str(error_char))

        code = m.group('code')
        name = m.group('name')
        output.append((code, name))

    return output

def format_error_code(entry):
    (code, name) = entry
    return output_format.format(code=code, name=name)

def generate_error_codes(messages, template, output):
    messages_text = read_all_text(messages)

    error_codes = read_error_codes(messages_text)

    template_text = read_all_text(template)

    formatted_error_codes = map(format_error_code, error_codes)
    formatted_error_codes = ''.join(formatted_error_codes)
    formatted_template = template_text.replace('{$errorCodes$}', formatted_error_codes)

    write_all_text(output, formatted_template)

    print('Generated {0} error codes.'.format(len(error_codes)))

if __name__ == '__main__':
    arguments = docopt(__doc__)
    generate_error_codes(
        arguments['--messages'],
        arguments['--template'],
        arguments['--output']
    )
