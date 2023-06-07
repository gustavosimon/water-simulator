-module(water_simulator).
-export([start/0, generate_molecule/1, handle_hydrogen/1, handle_oxygen/1, get_energy/0, combine_molecules_or_add_to_list/1]).

start() -> 
    Pid = spawn(?MODULE, combine_molecules_or_add_to_list, [[]]),
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
    Pid ! {message, "hydrogen"},
    ok.

handle_oxygen(Pid) ->
    get_energy(),
    Pid ! {message, "oxygen"},
    ok.

get_energy() -> 
    Min = 10000,
    Max = 30000,
    RandomValue = rand:uniform(Max - Min + 1) + Min,
    timer:sleep(RandomValue).

combine_molecules_or_add_to_list(_MoleculesList) ->

% 
% Está recebendo a molécula que está pronta para ser combinada
% Falta criar a lógica de verificar na lista se já possui moléculas disponíveis para fazer a combinação de água
% 

    receive
        {message, Molecule} -> 
            case Molecule of
                "hydrogen" -> io:format("Recebido um Hidrogenio!");
                "oxygen" -> io:format("Recebido um Oxigenio!")
            end
    end,


    combine_molecules_or_add_to_list([]).

% 1. Cada molécula gerada, hidrogênio e oxigênio deve ser um processo em Erlang; ok
% 2. O tempo para que cada molécula adquira energia suficiente deve variar entre 10s e 30s; ok
% 3. A geração de moléculas deve ser constante e de forma aleatória com intervalo de tempo parametrizável; ok
% 4. Cada processo deve ser identificado unicamente e apresentar uma mensagem quando criado informando esta identificação; ok
% 5. A aplicação deve identificar as combinações realizadas, apresentando a identificação dos elementos combinados;
 
% Fazer um novo processo que fica varrendo uma lista para saber se pode combinar as moleculas
% Salvar o PID e mover para o generate_molecule para ele saber para onde mandar a molécula pronta
% Fazer via mensagem 
% Enviar a molécula somente quando ela estiver pronta