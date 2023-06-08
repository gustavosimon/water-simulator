-module(water_simulator).
-export([start/0, generate_molecule/1, handle_hydrogen/1, handle_oxygen/1, get_energy/0, combine_molecules_or_add_to_list/2, combine/2, process_message/4]).

start() -> 
    Pid = spawn(?MODULE, combine_molecules_or_add_to_list, [[], []]),
    generate_molecule(Pid).

generate_molecule(PidA) ->
    timer:sleep(1000),
    RandomNumber = rand:uniform(2),
    case RandomNumber of
        1 -> Pid = spawn(?MODULE, handle_hydrogen, [PidA]),
            io:format("Gerado um Hidrogenio de ID ~p~n", [Pid]);
        2 -> Pid = spawn(?MODULE, handle_oxygen, [PidA]),
            io:format("Gerado um Oxigenio de ID ~p~n", [Pid])
    end,
    generate_molecule(PidA).

handle_hydrogen(Pid) ->
    get_energy(),
    io:format("A molécula de Hidrogênio obteve energia suficiente ~p~n", [self()]),
    Pid ! {self(), "hydrogen"},
    ok.

handle_oxygen(Pid) ->
    get_energy(),
    io:format("A molécula de Oxigênio obteve energia suficiente ~p~n", [self()]),
    Pid ! {self(), "oxygen"},
    ok.

get_energy() -> 
    Min = 10000,
    Max = 30000,
    RandomValue = rand:uniform(Max - Min + 1) + Min,
    timer:sleep(RandomValue).

combine_molecules_or_add_to_list(HydrogenList, OxygenList) ->
    Result = combine(HydrogenList, OxygenList),
    case Result of
        {combined, NewHydrogenList, NewOxygenList, CombinedItems} ->
            io:format("Os seguintes itens foram combinados: ~p~n", [CombinedItems]);
        {not_combined, NewHydrogenList, NewOxygenList, []} ->
            io:format("Não combinou nenhum item nessa iteração~n")
    end,
    receive
        {Pid, Molecule} ->
            {SecondNewHydrogenList, SecondNewOxygenList} = process_message(Molecule, Pid, NewHydrogenList, NewOxygenList)
    end,
    combine_molecules_or_add_to_list(SecondNewHydrogenList, SecondNewOxygenList).

combine(HydrogenList, OxygenList) ->
    case {length(HydrogenList), length(OxygenList)} of
        {N, M} when N >= 2, M >= 1 ->
            NewHydrogenList = lists:sublist(HydrogenList, 2, length(HydrogenList) - 2),
            NewOxygenList = tl(OxygenList),
            CombinedItems = lists:sublist(HydrogenList, 1, 2) ++ lists:sublist(OxygenList, 1, 1),
            {combined, NewHydrogenList, NewOxygenList, CombinedItems};
        _ ->
            {not_combined, HydrogenList, OxygenList, []}
    end.

process_message("hydrogen", Pid, HydrogenList, OxygenList) ->
    NewHydrogenList = [Pid | HydrogenList],
    {NewHydrogenList, OxygenList};

process_message("oxygen", Pid, HydrogenList, OxygenList) ->
    NewOxygenList = [Pid | OxygenList],
    {HydrogenList, NewOxygenList}.