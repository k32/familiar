%%--------------------------------------------------------------------
%% Copyright (c) 2026 EMQ Technologies Co., Ltd. All Rights Reserved.
%%--------------------------------------------------------------------

%% @doc Test fixture that adds code coverage capture to the child nodes.
%%
%% There's no configuration.
-module(familiar_cover).

-behavior(familiar_fixture).

%% behavior callbacks:
-export([init_per_node/4, cleanup_per_node/5]).

-export_type([conf/0]).

%%================================================================================
%% Type declarations
%%================================================================================

-type conf() :: #{}.

%%================================================================================
%% behavior callbacks
%%================================================================================

%% @private
init_per_node(Site, Node, _Conf, #{workdir := WD} = State) ->
  familiar:call(Site, cover, start, []),
  File = filename:join([WD, "cover_data", integer_to_list(erlang:monotonic_time())]),
  ok = filelib:ensure_dir(File),
  {ok, State#{cover_file => File}}.

%% @private
cleanup_per_node(Site, _Node, _Conf, #{cover_file := File}, _IsKill) ->
  ok = familiar:call(Site, cover, export, [File]),
  ok = cover:import(File).
