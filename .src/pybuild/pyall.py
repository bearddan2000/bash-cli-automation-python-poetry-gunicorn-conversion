import os
import logging


logging.basicConfig(level=logging.INFO)

def redo_readme(dir):
    FILE = os.path.join(dir, 'README.md')
    content = None
    with open(FILE, 'r') as fi:
        content = fi.read()
    
    content = content.replace('-web-', '-web-poetry-gunicorn-').replace('-cli-', '-cli-poetry-gunicorn-')
    content = content.replace('- python:latest', '- alpine:latest')
    content = content.replace('- python', '- python\n\t- poetry\n\t- gunicorn')

    with open(FILE, 'w') as fo:
        fo.write(content)

def main():
    import sys
    dir = sys.argv[1]
    if dir is None:
        for x in sys.argv:
            logging.info(x)
        logging.error('No directory sent, exiting.')
        exit(1)
    
    redo_readme(dir)

if __name__ == "__main__":
    main()