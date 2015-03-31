DART Url format:

next_bustrain.asp?sSwitch=returnSchedule&sSignID=99&sBusLineID=17130&ddlLineDirIDWithStop=171300%7C19020&ddlLineDirIDWithStop=

Terminology:

Transport: A DART train/bus/trolley. This is generalized, and we can show multiple transports with the same ID on the same map.
Stop: A DART stop, multiple different transports can stop at a stop.


Each DART stop has:
* bus number/train color/trolley
* stop id
* stop name
* direction


```
Proposed Schema:
transports:
   type: enum(bus, train, trolley)
   identifier: string (bus # or train color)

stops:

stop_transports:
```