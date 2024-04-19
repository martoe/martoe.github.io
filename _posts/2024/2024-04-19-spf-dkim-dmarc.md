---
layout: post
excerpt_separator: <!--more-->
title: "SPF/DKIM/DMARC Configuration for mailbox.org"
category: dev
tags:
comments: true
---

When sending emails with my `mailbox.org` account, I occasionally receive errors like the following:

```
The mail system <xxxxxx@gmail.com>: host gmail-smtp-in.l.google.com[142.250.147.27]
said: 550-5.7.26 This mail has been blocked because the sender is
unauthenticated. 550-5.7.26 Gmail requires all senders to authenticate with
either SPF or DKIM. 550-5.7.26  550-5.7.26  Authentication results:
550-5.7.26  DKIM = did not pass 550-5.7.26  SPF [bxm.at] with ip:
[80.241.56.151] = did not pass 550-5.7.26  550-5.7.26  For instructions on
setting up authentication, go to 550 5.7.26
https://support.google.com/mail/answer/81126#authentication
g4-20020a50d5c4000000b0056bf27dec57si5300544edj.105 - gsmtp (in reply to
end of DATA command)
```

Reason seems to be an error in my SPF/DKIM/DMARC setup.
I am using the `mailbox.org` mail provider with my own domains (in this case `bxm.at`), which are hosted
by `all-inkl.com`.
After looking into the documentation
of [mailbox.org](https://kb.mailbox.org/en/private/custom-domains/spf-dkim-and-dmarc-how-to-improve-spam-reputation-and-avoid-bounces/)
and [all-inkl.com](https://all-inkl.com/wichtig/anleitungen/kas/tools/dns-werkzeuge/dmarc_562.html), I added the
following DNS entries to the domain:

| Name               | Type  | Data                                             |
|--------------------|-------|--------------------------------------------------|
| mbo0001._domainkey | CNAME | mbo0001._domainkey.mailbox.org.                  |
| mbo0002._domainkey | CNAME | mbo0002._domainkey.mailbox.org.                  |
| mbo0003._domainkey | CNAME | mbo0003._domainkey.mailbox.org.                  |
| mbo0004._domainkey | CNAME | mbo0004._domainkey.mailbox.org.                  |
|                    | TXT   | v=spf1 mx include:mailbox.org a ?all             |
| _dmarc             | TXT   | v=DMARC1; p=quarantine; rua=mailto:xxxxxx@bxm.at |

The configuration looks fine now:

![]({{ site.baseurl }}/assets/img/spf-dkim-dmarc.png)

Just for reference, these were the values before my change:

| Name   | Type | Data             |
|--------|------|------------------|
|        | TXT  | v=spf1 mx a ?all |
| _dmarc | TXT  | v=DMARC1; p=none |

