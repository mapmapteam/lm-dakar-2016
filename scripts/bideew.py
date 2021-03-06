#!/usr/bin/env python
# Copyright (c) 2009 Alexandre Quessy, Arjan Scherpenisse
# See LICENSE for details.
"""
Sends OSC messages using txosc
"""
from twisted.internet import reactor
from twisted.internet import defer
from txosc import osc
from txosc import async

VERBOSE = False


def later(delay):
    """
    Returns a Deferred that fires after a given delay.

    @param delay: Duration in seconds.
    @type delay: C{float}
    @rtype: L{twisted.internet.defer.Deferred}
    """
    ret = defer.Deferred()

    def _callable(ret):
        ret.callback(None)

    delayed_call = reactor.callLater(delay, _callable, ret)
    return ret


class MapMapController(object):
    def __init__(self, host="localhost", port=12345):
        self._host = host
        self._port = port
        self._client = async.DatagramClientProtocol()
        self._client_port = reactor.listenUDP(0, self._client)
        self._verbose = False

    def send(self, message):
        self._client.send(message, (self._host, self._port))
        self._log("Sent %s to %s:%d" % (message, self._host, self._port))

    def _log(self, text):
        if VERBOSE:
            print(text)


if __name__ == "__main__":
    @defer.inlineCallbacks
    def run():
        sender = MapMapController()
        yield sender.send(osc.Message("/hello", 1, 3.123, "world"))
        yield later(1.0) # wait 1 second
        yield sender.send(osc.Message("/hello", 2, 3.123, "world"))
        reactor.stop()

    def _later():
        run()

    reactor.callLater(0.001, _later)
    reactor.run()
