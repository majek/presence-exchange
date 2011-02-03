%% The contents of this file are subject to the Mozilla Public License
%% Version 1.1 (the "License"); you may not use this file except in
%% compliance with the License. You may obtain a copy of the License at
%% http://www.mozilla.org/MPL/
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%%
%% The Original Code is presence-exchange.
%%
%% The Initial Developers of the Original Code are Rabbit Technologies
%% Ltd and Tony Garnock-Jones.
%%
%% Portions created by Rabbit Technologies Ltd or by Tony Garnock-Jones
%% are Copyright (C) 2010 Rabbit Technologies Ltd and Tony Garnock-Jones.
%%
%% All Rights Reserved.
%%
%% Contributor(s): ______________________________________.
-module(presence_exchange).
-include_lib("rabbit_common/include/rabbit.hrl").

-behaviour(rabbit_exchange_type).

-rabbit_boot_step({?MODULE,
                   [{description, "exchange type x-presence"},
		    {mfa,         {rabbit_registry, register,
				   [exchange, <<"x-presence">>, ?MODULE]}},
                    {requires,    rabbit_registry},
                    {enables,     kernel_ready}]}).

-export([description/0, route/2]).
-export([validate/1, create/2, recover/2, delete/3, add_binding/3,
	 remove_bindings/3, assert_args_equivalence/2]).

encode_binding_delivery(DeliveryXName,
                        Action,
                        #binding{source = #resource{name = XName},
                                 key = BindingKey,
                                 destination = #resource{name = QName}}) ->
    Headers = [{<<"action">>, longstr, atom_to_list(Action)},
               {<<"exchange">>, longstr, XName},
               {<<"queue">>, longstr, QName},
               {<<"key">>, longstr, BindingKey}],
    rabbit_basic:delivery(false, false, none,
                          rabbit_basic:message(
			    DeliveryXName, <<>>, [{headers, Headers}], <<>>),
			  undefined).

description() ->
    [{name, <<"x-presence">>},
     {description, <<"Presence exchange">>}].

route(#exchange{name = Name}, _Delivery) ->
    rabbit_router:match_routing_key(Name, '_').

validate(_X) -> ok.
create(_Tx, _X) -> ok.
recover(_X, _Bs) -> ok.
delete(_Tx, _X, _Bs) -> ok.

add_binding(_Tx, #exchange{name = XName}, B) ->
    rabbit_basic:publish(encode_binding_delivery(XName, bind, B)),
    ok.

remove_bindings(_Tx, #exchange{name = XName}, Bs) ->
    _ = [rabbit_basic:publish(encode_binding_delivery(XName, unbind, B))
         || B <- Bs],
    ok.

assert_args_equivalence(X, Args) ->
    rabbit_exchange:assert_args_equivalence(X, Args).
