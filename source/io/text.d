/**
 * Copyright: Copyright Jason White, 2015
 * License:   $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Jason White
 *
 * TODO: Find a more elegant way of reading and writing text.
 */
module io.text;

import io.stream;

/**
 * Serializes the given arguments to a text representation followed by a new
 * line.
 */
size_t print(T...)(Sink sink, auto ref T args)
{
    import std.conv : to;

    size_t length;

    foreach (arg; args)
        length += sink.write(arg.to!string);

    return length;
}

/// Ditto
size_t print(T...)(shared(Sink) sink, auto ref T args)
{
    import std.algorithm : forward;
    synchronized (sink)
        return (cast(Sink)sink).print(forward!args);
}

/// Ditto
size_t print(T...)(auto ref T args)
    if (T.length > 0 && !is(T[0] : Sink) && !is(T[0] : shared(Sink)))
{
    import io.file.stdio : stdout;
    import std.algorithm : forward;
    return stdout.print(forward!args);
}

unittest
{
    import io.file.pipe;
    import std.typecons : tuple;
    import std.typetuple : TypeTuple;

    // First tuple value is expected output. Remaining are the types to be
    // printed.
    alias tests = TypeTuple!(
        tuple(""),
        tuple("Test", "Test"),
        tuple("[4, 8, 15, 16, 23, 42]", [4, 8, 15, 16, 23, 42]),
        tuple("The answer is 42", "The answer is ", 42),
        tuple("01234567890", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0),
        );

    foreach (t; tests)
    {
        auto f = pipe();
        immutable output = t[0];
        char[output.length] buf;
        assert(f.writeEnd.print(t[1 .. $]) == output.length);
        assert(f.readEnd.read(buf) == buf.length);
        assert(buf == output);
    }
}

/**
 * Serializes the given arguments to a text representation followed by a new
 * line.
 */
size_t println(T...)(Sink sink, auto ref T args)
{
    import std.conv : to;

    size_t length;

    foreach (arg; args)
        length += sink.write(arg.to!string);

    length += sink.write("\n");

    return length;
}

/// Ditto
size_t println(T...)(shared(Sink) sink, auto ref T args)
{
    import std.algorithm : forward;
    synchronized (sink)
        return (cast(Sink)sink).println(forward!args);
}

/// Ditto
size_t println(T...)(auto ref T args)
    if (T.length > 0 && !is(T[0] : Sink) && !is(T[0] : shared(Sink)))
{
    import io.file.stdio : stdout;
    import std.algorithm : forward;
    return stdout.println(forward!args);
}

unittest
{
    import io.file.pipe;
    import std.typecons : tuple;
    import std.typetuple : TypeTuple;

    // First tuple value is expected output. Remaining are the types to be
    // printed.
    alias tests = TypeTuple!(
        tuple("\n"),
        tuple("Test\n", "Test"),
        tuple("[4, 8, 15, 16, 23, 42]\n", [4, 8, 15, 16, 23, 42]),
        tuple("The answer is 42\n", "The answer is ", 42),
        tuple("01234567890\n", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0),
        );

    foreach (t; tests)
    {
        auto f = pipe();
        immutable output = t[0];
        char[output.length] buf;
        assert(f.writeEnd.println(t[1 .. $]) == output.length);
        assert(f.readEnd.read(buf) == buf.length);
        assert(buf == output);
    }
}

/**
 * Serializes the given arguments according to the given format specifier
 * string.
 */
@property size_t printf(T...)(Sink sink, string format, auto ref T args)
{
    // TODO
    return 0;
}

/// Ditto
size_t printf(T...)(shared(Sink) sink, string format, auto ref T args)
{
    import std.algorithm : forward;
    synchronized (sink)
        return (cast(Sink)sink).printf(format, forward!args);
}

/// Ditto
@property size_t printf(T...)(string format, auto ref T args)
    if (T.length > 0 && !is(T[0] : Sink) && !is(T[0] : shared(Sink)))
{
    import io.file.stdio : stdout;
    import std.algorithm : forward;
    return stdout.printf(forward!(format, args));
}

/**
 * Like $(D writef), but also writes a new line.
 */
@property size_t printfln(T...)(Sink sink, string format, auto ref T args)
{
    // TODO
    return 0;
}

/// Ditto
size_t printfln(T...)(shared(Sink) sink, string format, auto ref T args)
{
    import std.algorithm : forward;
    synchronized (sink)
        return (cast(Sink)sink).printfln(format, forward!args);
}

/// Ditto
@property size_t writefln(T...)(string format, auto ref T args)
    if (T.length > 0 && !is(T[0] : Sink) && !is(T[0] : shared(Sink)))
{
    import io.file.stdio : stdout;
    import std.algorithm : forward;
    return stdout.printfln(forward!(format, args));
}
