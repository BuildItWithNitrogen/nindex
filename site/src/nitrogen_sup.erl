%% -*- mode: nitrogen -*-
%% vim: ts=4 sw=4 et
-module(nitrogen_sup).
-behaviour(supervisor).
-export([
    start_link/0,
    init/1
]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    ni_links:init_db(),
    application:load(nitrogen_core),
    application:start(simple_cache),
    application:start(crypto),
    application:start(nprocreg),
    application:start(simple_bridge),

% DETS Supervisor
%    DETSSup = #{
%        id=>ni_dets_sup,
%        start=>{ni_dets_sup, start_link, []},
%        shutdown=>2000,
%        type=>supervisor,
%        modules=>[ni_dets_sup]
%    },

    {ok, { {one_for_one, 5, 10}, [
%        DETSSup
    ]} }.
