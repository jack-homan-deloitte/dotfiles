from __future__ import with_statement

import logging
import os
import sys

logger = logging.getLogger(__name__)


# Enable Pretty Printing for stdout
def _pprint_displayhook(value):
    import pprint

    if value is not None:
        try:
            import __builtin__
            __builtin__._ = value
        except ImportError:
            import builtins
            builtins._ = value

        pprint.pprint(value)

sys.displayhook = _pprint_displayhook


# bpython + django
try:
    from django.core.management import setup_environ
    import settings
    setup_environ(settings)
except:
    pass


# If we're working with a Django project, set up the environment
if 'DJANGO_SETTINGS_MODULE' in os.environ:
    from django.db.models.loading import get_models
    from django.test.client import Client
    from django.test.utils import (setup_test_environment,
                                   teardown_test_environment)
    from django.conf import settings as S

    class DjangoModelAggregate(object):
        def __init__(self):
            for m in get_models():
                setattr(self, m.__name__, m)

    M = DjangoModelAggregate()
    C = Client()


def edit(editor=None, *args, **kwargs):
    """
    Open a file in a preferred editor and execute it after the editor exits.

    `editor` specifies what editor to execute. The default is to infer it from
    the $EDITOR environment variable. Any additional positional arguments will
    be passed to the editor's process as argv.

    Keyword only arguments include:
        `content`: An initial set of lines to include in the created file
                   (default: None)
        `globals`: A dict containing the globals in which to execute the file
                   (default: globals())
        `write_globals`: A boolean specifying whether to write out a commented
                         out series of lines containing the globals to the
                         created file (useful for tab completion, default:
                         True)
        `retry`: Prompt to re-edit the file if an exception is raised on
                 execution (default: False)
        `add_history`: A callable that will be called for each line in the
                       edited file, that should add the line to the history, or
                       None to turn this feature off. (default:
                       `readline.add_history`)
        `filter_globals`: A function that will be used to filter the globals
                          when outputted. The default is to exclude any name
                          that starts with an underscore.

    """

    import os
    import subprocess
    import tempfile
    import traceback

    try:
        from readline import add_history
    except ImportError:
        add_history = kwargs.get("add_history")
    else:
        add_history = kwargs.get("add_history", add_history)

    editor = editor or os.environ.get("EDITOR")
    content = kwargs.get("content", "")
    globals_ = kwargs.get("globals", globals())
    write_globals = kwargs.get("write_globals", True)
    retry = kwargs.get("retry", False)
    matches = kwargs.get("filter_globals", lambda n : not n.startswith("_"))


    with tempfile.NamedTemporaryFile(delete=False, suffix=".py") as tmp:
        if content:
            tmp.writelines(content)
        if globals_ and write_globals:
            tmp.write("# Globals:\n")
            matching = (g for g in globals_ if matches(g))
            tmp.writelines("#    {}\n".format(g) for g in matching)

    while True:
        subprocess.call((editor, tmp.name,) + args)

        if add_history is not None:
            with open(tmp.name) as f:
                for line in f:
                    add_history(line.rstrip())

        try:
            execfile(tmp.name, globals_)
        except Exception:
            if retry:
                traceback.print_exc()
                answer = raw_input("Continue editing? [y]: ")
                if not answer or answer.lower() == "y":
                    continue
            raise

        break

    os.remove(tmp.name)


try:
    import readline
except ImportError:
    logger.error("Module readline not available.")
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")
    del readline, rlcompleter


del logger, logging, os, sys