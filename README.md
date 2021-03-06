# RabbitMQ "Presence Exchange" Plugin

Extends RabbitMQ Server with support for a new experimental exchange
type, `x-presence`. An exchange of type `x-presence` notifies queues
that are bound to it when other bindings appear and disappear.

Messages are sent out from an `x-presence` exchange to attached queues
when a new binding appears or an existing binding disappears. The
message sent out has an empty body, with all the interesting
information in the `headers` property of the message headers:

    Key       Type  Description
    -----------------------------------------------------------------
    action    str   Either "bind" or "unbind"
    exchange  str   The name of the exchange being bound/unbound
    queue     str   The name of the queue being bound/unbound
    key	      str   The binding key supplied at the time of binding

Publishing messages to a 'x-presence' exchange is a bad idea. Right
now it behaves like a 'fanout' exchange, but this behavior may change
in the future.

## Licensing

This plugin is licensed under the MPL. The full license text is
included with the source code for the package. If you have any
questions regarding licensing, please contact us at
<info@rabbitmq.com>.
