---
title: Instant messaging woes
description: MSN sucks.
tags: msn, linux, jabber
---

MSN sucks. It arbitrarily blocks my contacts. After adding a new contact
there is a reasonably high chance that the contact will appear offline
for me for the time being. Offline messages work only occasionally.
Packet loss that does not affect SSH, VPN or [Jabber] connections
makes MSN server drop the connection to me. Group chat hasn't worked
since november 2011. There is (was?) a hard limit on how many contacts
you are allowed to have.

All of those issues have
been confirmed at with least two of the following clients: Pidgin,
Empathy, Mercury, imo.im and Ebuddy. Most of them are bugs in the
repsective clients, but all of it is caused by the simple fact that
Microsoft does not like users having their way with their communication.
Using the officially supported client is not an option, as it requires
using a propertiary, adversarial and utterly limited operating system.

Unless a magical fix appears for these problems, I'm leaving MSN by the
end of 2012.

[Jabber] is better, but not painless. Most public servers are overwhelmed
by the amount of clients and DoS attacks. Google accounts also double as
Jabber accounts and seem to work well, but every bit of your conversations
is logged in Google servers. The actual problem seems again to be the
protocol itself, this time being too complex too be implemented efficiently.
In spite of this, Jabber is usually very reliable and useful means of
communication and free of all the problems I'm experiencing with MSN.

There are improvements in the works, of course. [PSYC] is lightwieght enough
to mitigate the scalabality hassles of Jabber and [Secure Share] looks
promising as a platform for communication facilities to come. What else
is worth taking a look at?

[Jabber]:http://www.jabber.org/
[PSYC]:http://about.psyc.eu/
[Secure Share]:http://secushare.org/
