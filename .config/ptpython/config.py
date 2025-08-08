def configure(repl):
    # Load favorite libraries
    import builtins
    import math
    import collections
    import heapq
    import bisect
    import itertools
    import functools
    import operator
    import typing

    # Make them available globally
    builtins.math = math
    builtins.collections = collections
    builtins.heapq = heapq
    builtins.bisect = bisect
    builtins.itertools = itertools
    builtins.functools = functools
    builtins.operator = operator
    builtins.typing = typing

    # Optional: Define shorter aliases
    builtins.deque = collections.deque
    builtins.defaultdict = collections.defaultdict
    builtins.Counter = collections.Counter
    builtins.heapq = heapq
    builtins.bisect = bisect
    builtins.itertools = itertools
    builtins.functools = functools

    repl.use_code_colorscheme("native")
    repl.color_depth = "DEPTH_24_BIT"

    # You can also define handy functions or templates here
    def show(*args):
        for x in args:
            print(x)
    builtins.show = show
