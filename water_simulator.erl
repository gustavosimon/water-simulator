-module(water_simulator).
-export([start/0, generate_molecule/0, handle_hydrogen/0, handle_oxygen/0, get_energy/0]).

start() -> 
    generate_molecule().

generate_molecule() ->
    timer:sleep(1000),
    RandomNumber = rand:uniform(2),
    case RandomNumber of
        1 -> Pid = spawn(?MODULE, handle_hydrogen, []),
            io:format("Gerado um Hidrogenio de ID ~p~n", [Pid]);
        2 -> Pid = spawn(?MODULE, handle_oxygen, []),
            io:format("Gerado um Oxigenio de ID ~p~n", [Pid])
    end,
    generate_molecule().

handle_hydrogen() ->
    get_energy(),
    ok.

handle_oxygen() ->
    get_energy(),
    ok.

get_energy() -> 
    Min = 10000,
    Max = 30000,
    RandomValue = rand:uniform(Max - Min + 1) + Min,
    timer:sleep(RandomValue).


% 1. Cada molécula gerada, hidrogênio e oxigênio deve ser um processo em Erlang; ok
% 2. O tempo para que cada molécula adquira energia suficiente deve variar entre 10s e 30s; ok
% 3. A geração de moléculas deve ser constante e de forma aleatória com intervalo de tempo parametrizável; ok
% 4. Cada processo deve ser identificado unicamente e apresentar uma mensagem quando criado informando esta identificação; ok
% 5. A aplicação deve identificar as combinações realizadas, apresentando a identificação dos elementos combinados;
 
% Fazer um novo processo que fica varrendo uma lista para saber se pode combinar as moleculas
% Salvar o PID e mover para o generate_molecule para ele saber para onde mandar a molécula pronta
% Fazer via mensagem 
% Enviar a molécula somente quando ela estiver pronta