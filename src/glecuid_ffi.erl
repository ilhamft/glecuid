-module(glecuid_ffi).

-export([bump_or_initialize_counter/1, hash/1]).

bump_or_initialize_counter(InitialValue) ->
    try
        CounterRef = persistent_term:get({?MODULE, "Counter"}),
        counters:add(CounterRef, 1, 1),
        counters:get(CounterRef, 1)
    catch
        _:_ ->
            initialize_counter(InitialValue),
            InitialValue
    end.

initialize_counter(InitialValue) ->
    CounterRef = counters:new(1, [atomics]),
    counters:put(CounterRef, 1, InitialValue),
    persistent_term:put({?MODULE, "Counter"}, CounterRef).

hash(Data) ->
    crypto:hash(sha3_512, Data).
