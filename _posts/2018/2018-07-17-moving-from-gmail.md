---
layout:   post
title:    "Moving From Gmail & Co"
category: dev
tags:     blog
comments: true
---

Until recently, I have been using Google services for most of my daily business:
For [email communication](https://mail.google.com/), [contacts and addresses](https://contacts.google.com/), [appointments and reminders](https://calendar.google.com/), [notes](https://keep.google.com/), [navigation](https://maps.google.com/), and of course for [searching the internet](https://www.google.com/).

Choosing Google was nothing but a pragmatic decision: their applications are simple, lean, easy-to-use, rock-solid - and they are free.

But over the years, I became more and more uneasy about putting all my data into one hand: I discarded [Google Drive](https://drive.google.com/) in favour of a self-hostet [Nextcloud](https://nextcloud.com/) service, I opted out from [Google+](https://plus.google.com/) (which was not hard) and stopped using [Google Photos](https://photos.google.com/) (though I am still using [Picasa](https://picasa.google.com/) locally).

Finally, sensitized by those [GDPR](https://www.eugdpr.org/) discussions of the last weeks, I decided to make the final step: **finding an alternate provider for mail and calendar services**.

## My requirements

* an email service with about 5 GB storage
* use my own email address domain
* a fast and easy-to-use webmail (I don't use email clients)
* an address book that can be synchronized to my Android phone
* a calender that can be accessed both with a browser and with my Android phone


## My choice: mailbox.org

I didn't spend much time on evaluating different providers. Very quickly I stumbled upon [Posteo](https://posteo.de/) and [mailbox.org](https://mailbox.org/), both German services that seem to take privacy seriously. Mailbox.org has a more detailled pricing sheet and a 30-days-trial, so I chose that one.

The 30-days trial account offers 100MB space and a single email alias. This is sufficient if you want to check if data migration is possible and to create an email alias with your own domain name, but for a complete migration you have to transfer some money (similar to a prepaid phone). 
In my case, it took two days until the SEPA transfer was credited to my account and the whole package was unlocked.

# 1. Configuration

For me, the most important part is that I can use my own email address right from the start. The required steps are described in the [knowledge base](https://userforum.mailbox.org/knowledge-base/article/e-mail-adressen-der-eigenen-domain-nutzen), but the steps are pretty streight forward:

1. Got to "Settings -> mailbox.org -> E-mail Aliases"
1. Enter the email address (with your own domain name) in the "Add external address" section
1. You receive an validation error message because the DNS entry is missing for your domain
1. On the DNS panel of your domain provider, create this DNS record
1. Wait a few hours
1. Again enter the email in the "Add external address" section - this time it succeeds
1. Change the main address to this new address

Now your own email address will act as login name, default sender address, and reply-to address (which means you don't need the `@mailbox.org` address anymore).

To actually receive the emails for this address, choose one out of two options:

1. On the mail panel of your domain provider, add a forward rule for your email address to the `@mailbox.org` address (takes a few minutes until effective)
2. On the DNS panel of your domain provider, replace the existing `MX` DNS records with the following (takes a few **hours** until effective):

        domainname.com.  IN MX 10 mxext1.mailbox.org.
        domainname.com.  IN MX 10 mxext2.mailbox.org.
        domainname.com.  IN MX 20 mxext3.mailbox.org.

Notes that when using the second option:
  
* **All** emails for this domain are routed to mailbox.org (which effectively disables all mailboxes and forwarding rules of your domain provider).
* You may even remove the alias for the `@mailbox.org` address - but I recommend to keeping it so that you can still receive email even if the DNS configuration is messed up. 

# 2. Data migration

(based on [this post](https://userforum.mailbox.org/topic/umzug-von-google-nach-mailbox-org) and my own experience)

## Contacts

1. With [Google Takout](https://takeout.google.com/), create a ZIP file containing the contacts in "vCard" format
1. Download and unzip the file
1. In the mailbox.org address book, choose "import" and upload the unzipped `All Contacts.vcf` files

In addition to the "All Contacts" list, the takout zip file contains a contact list for each label. I found no way to import the "label" information to the mailbox.org address book. 

## Calendar

1. With [Google Takout](https://takeout.google.com/), create a ZIP file containing the calendars in "iCal" format
1. Download and unzip the file
1. For each exported calendar,
    * On the mailbox.org "Calendar" page, create a new calendar
    * Choose "import" and upload the unzipped "ics" file

The mailbox.org calendar doesn't support email reminders; such reminders won't be migrated.
 
## Email

1. Install [Thunderbird](https://www.thunderbird.net/) and create both the Gmail and mailbox.org account (using IMAP)
1. Create an appropriate folder structure within the mailbox.org account
1. Move all mails (folder by folder) from the Gmail account to the mailbox.org account 

Note that Gmail uses the concept of "labels" (aka "tags") to organize emails. Each label is mapped to an IMAP folder, which means that an email with multiple labels is available in multiple IMAP folders. So when transfering your email folder-by-folder, you will probably end with duplicate emails in your mailbox-org account.

Also note that Gmails "All mail" folder contains **every email** of the whole Gmail account that has not explicitly been deleted (i.e. sent mails, received mails, archived mails, and labeled mails), so it probably would be a bad idea to copy the whole folder to your mailbox.org account.

# 3. Android phone synchronization

(based on [this knowledge-base article](https://userforum.mailbox.org/knowledge-base/article/datenabgleich-uebersicht))

For emails, any email app will do (even [Gmail](https://play.google.com/store/apps/details?id=com.google.android.gm)!). Many people recommend [K-9](https://play.google.com/store/apps/details?id=com.fsck.k9), but I don't like its UX, so I chose the preinstalled email app.

The [OX Sync App](https://play.google.com/store/apps/details?id=com.openexchange.mobile.syncapp.enterprise) synchronizes contacts and calendars. Once this app is installed and configured, the mailbox.org address books and calendars are available to other apps.
For now, I am still using the [Google Calendar app](https://play.google.com/store/apps/details?id=com.google.android.calendar) and [Google Contacts app](https://play.google.com/store/apps/details?id=com.google.android.contacts).
