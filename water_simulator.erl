-module(water_simulator).
-export([start/0, generate_molecule/0, handle_hydrogen/0, handle_oxygen/0]).

start() -> 
    generate_molecule().

generate_molecule() ->
    timer:sleep(1000),
    RandomNumber = rand:uniform(2),
    case RandomNumber of
        1 -> spawn(?MODULE, handle_hydrogen, []);
        2 -> spawn(?MODULE, handle_oxygen, [])
    end,
    generate_molecule().

handle_hydrogen() ->
    io:format("Gerado um Hidrogenio~n"),
    ok.

handle_oxygen() ->
    io:format("Gerado um Oxigenio~n"),
    ok.

% Criar uma função para gerar moléculas aleatoriamente (cada molécula deve um novo processo Erlang)
%  A função de geração de moléculas deve ser constante e aleatória a cada X tempo
% Criar um controle para verificar se as moléculas já estão prontas para serem utilizadas

% 1. Cada molécula gerada, hidrogênio e oxigênio deve ser um processo em Erlang; ok
% 2. O tempo para que cada molécula adquira energia suficiente deve variar entre 10s e 30s;
% 3. A geração de moléculas deve ser constante e de forma aleatória com intervalo de tempo parametrizável; ok
% 4. Cada processo deve ser identificado unicamente e apresentar uma mensagem quando criado informando esta identificação;
% 5. A aplicação deve identificar as combinações realizadas, apresentando a identificação dos elementos combinados;