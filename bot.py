# bot.py
import os
import discord
import math
import time

client = discord.Client()

TOKEN = "DISCORD_TOKEN_HERE"

prefix = "w!"

footer = "WarnBot BETA"

#colors
red = discord.Color.from_rgb(255,0,0)
orange = discord.Color.orange()
yellow = discord.Color.from_rgb(255,255,0)
green = discord.Color.green()
blue = discord.Color.blue()
purple = discord.Color.purple()
pink = discord.Color.from_rgb(255, 0, 255)
black = discord.Color.from_rgb(1, 1, 1)
white = discord.Color.from_rgb(254, 254, 254)
grey = discord.Color.from_rgb(150,150,150)

#messages
helpMessage = """
**Info:**
WarnBot website: [https://warnbot.net](https://warnbot.net \"Our Website!\")
Invite WarnBot: [https://invite.warnbot.net](https://invite.warnbot.net \"Invite me to Your Server!\")
__Prefix__: **{prefix}**

**General Commands:**
•*invite*: Gets the links to invite the bot and to the support server
•*updates*: See the bot's update log
•*vote*: Vote for the bot on verified bot lists
•*disc-tips*: Useful Discord tips
•*ping*: Pong!
•*cool-servers*: See some servers that WarnBot suggests
•*info*: Get some info about the bot, and links to submit requests and feedback.

**Moderation Commands:**
•*clear <Number>*: Clear specified number of previous messages. (Max 100)
•*mute <@user> (Reason)*: Mute mentioned member for listed reason
•*unmute <@user>*: Unmute mentioned user
•*warn <@user> (Reason)*: Warn mentioned member for listed reason
•*kick <@user> (Reason)*: Kick mentioned member for listed reason
•*ban <@user> (Reason)*: Ban mentioned member for listed reason
•*unban <userId>*: Unban given member
•*announce <announcement>*: Announce something in the server you want to announce it in
•*rules (#channel) <rules>*: Make the rules of the server you use the command in. If rule channel isn't named "rules", mention the channel you want the rules to be sent in.
•*talk <text>*: Talk as WarnBot
""".format(prefix=prefix)

inviteMessage = """
__Invite this bot!__
https://invite.warnbot.net

__Invite to our Support Server!__
https://support.warnbot.net
"""

updatesMessage = """
**JavaScript Build:**
__0.1:__ Basic Common Moderation Commands
__0.2:__ Announce, Rules, & Update Log Commands
__0.3:__ Vote, Tips & Ping Commands added, fixed Clear command to delete an accurate number of messages
__0.4:__ Talk, Suggest, Cool Servers Commands added, Updated some error messages, fixed Ping command
__0.5:__ WarnBot [website](https://warnbot.net) released, added more tips to disc-tips command

**Lua Build:**
__0.5:__ Complete rewrite, lost JavaScript build, Lua unusable due to horrible latency

**Python Build:**
__0.5:__ 2nd Complete rewrite, more reliable hosting.
"""

voteMessage = """
`Top.gg`: https://top.gg/bot/635977560492081162
`DiscordBotList.com`: https://discordbotlist.com/bots/warnbot
`BotsforDiscord.com`: https://botsfordiscord.com/bot/635977560492081162
`botrix.tk`: https://botrix.tk/bots/635977560492081162

(Please vote, it would greatly help)
"""

disc_tipsMessage = """
`1)` **Want to mention someone who isn't in your server or has been banned?**
 Try doing this! \"<@{Put id of the user here}>\" Example: "\<@123456789987654321>"
 
 `2)` **Want to find the id of a user?**
 In settings, go to \"Appearance\" (under \"App Settings\") and toggle Developer Mode on. Once you have done so, find the user you want to get the id of, and right-click their card.
 
 `3)` **Want to \"open\" or \"close\" your DMs?**
 Open settings, and go to \"Privacy & Safety\". Toggle the first switch. If you want to \"close\" them, toggle it so it turns gray, and press yes. If you want to \"open\" them, toggle it so it turns blue, and press yes.
 
 `4)` **Want to change to light mode or to dark mode?**
 Open settings, and go to \"Appearance\". There, you should see something that says \"Theme\". Right under that, choose the mode you want, and click on it once. It may take a second for it to switch.
 
 `5)` **Want Discord to stop changing your \":)\"s to :slight_smile:s?**
 Open settings. Go to \"Text & Images\". Scroll down until you see the :slight_smile: emoji. Toggle the switch to the right of it so it turns gray. If you want to re-enable it, toggle it again so it turns blue.
"""

cool_serversMessage = """
**WarnBot Support:** https://support.warnbot.net
> Have questions? Want help with commands? Join our server!

**Discord Townhall:** https://discord.gg/townhall
> Chill with Discord users in Discord's official townhall!

**Discord Emotes:** https://discord.gg/NCzM9WM
> Get access to tons more of amazing Discord emojis! *(Nitro users only)*

That’s all for now, check back again later!
"""

infoMessage = """
WarnBot was created by `Urxpaly45#0001` (<@439198909009756169>) on `11/21/2019`. It is now verified, and in over **2000** servers!

If you have feedback, or need help of any kind, please fill out the appropriate form.

**Ban Appeals:** https://appeals.warnbot.net
**Bug Reports:** https://bugs.warnbot.net
**Concerns:** https://concerns.warnbot.net
**Suggestions:** https://suggestions.warnbot.net
"""

def bool(value):
    if value == False or value == "False" or value == 0 or value == "0":
        return False
    elif value == True or value == "True" or value == 1 or value == "1":
        return True
    else:
        Error


def createEmbed(title, description, color, footer):
    embed = discord.Embed(
        title = title,
        description = description,
        color = color
    )
    embed.set_footer(text = footer)
    return embed

def getRange(start, end):
    returnList = []
    if start > end:
        for x in range(start-end+1):
            returnList.insert(x, start-x)
    elif start < end:
        for x in range(end-start):
            returnList.insert(x, start+x)
    return returnList

def getArg(message, argNum): # argNum = 5; argNum = [1,3,5]; argNum = [1,[4,6]]; argNum = [[1,"+"]]
    args = message.split(" ")
    returnStr = ""
    if type(argNum) == type(1):
        if len(args) < argNum+1:
            return ""
        else:
            return args[argNum]
    elif type(argNum) == type([1]):
        i = 0
        for x in argNum:
            i += 1
            if type(x) == type(1):
                if i == len(argNum):
                    returnStr += args[x]
                else:
                    returnStr += args[x] + " "
            elif type(x) == type([1]):
                start = -1
                end = -1
                for num in x:
                    if start == -1:
                        start = num
                    elif type(num) == type(1):
                        end = num
                    else:
                        end = len(args)
                for num in getRange(start, end):
                    if num+1 == end:
                        returnStr += args[num]
                    else:
                        returnStr += args[num] + " "
    return returnStr

def toInt(string):
    try:
        return int(string)
    except:
        return False

def checkPurgeable(message):
    return True

@client.event
async def on_ready():
    print(f"{client.user} has connected to Discord!")
    await client.change_presence(status=discord.Status.online, activity=discord.Game(f"w!help; Serving {len(client.guilds)} servers!"))

@client.event
async def on_message(message):
    await client.change_presence(status=discord.Status.online, activity=discord.Game(f"w!help; Serving {len(client.guilds)} servers!"))
    if message.author.bot == False:
        if message.content.startswith(prefix):
            errored = False
            try:
                # command
                command = getArg(message.content.lower(),0)
                if command == prefix+"help":
                    await message.reply(embed=createEmbed(f"Help", helpMessage, green, footer))
                elif command == prefix+"invite": # General Commands
                    await message.reply(embed=createEmbed(f"Invite Links", inviteMessage, green, footer))
                elif command == prefix+"updates":
                    await message.reply(embed=createEmbed(f"Help", updatesMessage, green, footer))
                elif command == prefix+"vote":
                    await message.reply(embed=createEmbed(f"Vote Links", voteMessage, green, footer))
                elif command == prefix+"disc-tips":
                    dm = await message.author.create_dm()
                    await dm.send(embed=createEmbed(f"Here are some tips!", disc_tipsMessage, green, footer))
                elif command == prefix+"ping":
                    time_then = time.monotonic()
                    pinger = await message.reply("__*`Pinging...`*__")
                    ping = '%.2f' % (1000*(time.monotonic()-time_then))
                    await pinger.edit(content=f":ping_pong: \n **Ping:** __**`{ping}ms`**__")
                elif command == prefix+"cool-servers":
                    dm = await message.author.create_dm()
                    await dm.send(embed=createEmbed(f"Here are some servers I suggest joining!", cool_serversMessage, green, footer))
                elif command == prefix+"info":
                    await message.reply(embed=createEmbed(f"Information:", infoMessage, green, footer))
                elif command == prefix+"clear": # Moderation Commands
                    if message.author.guild_permissions.manage_messages == True:
                        number = getArg(message.content,1)
                        error = "**UNKNOWN ERROR**"
                        try:
                            error = f"Invalid Argument 1. Expected `Number`, got \"{number}\""
                            number = int(number)+1
                            if number-1 > 100:
                                dm = await message.author.create_dm()
                                await dm.send(f"You attempted to delete {number-1} messages, however the maximum is 100, so I'm deleting 100 instead.")
                                number = 100
                            elif number == 101:
                                number = 100
                            error = f"Insufficient Permissions to clear {number} messages. Requires permission `Manage Messages`."
                            deleted = await message.channel.purge(limit=number, check=checkPurgeable, bulk=True)
                            deletionReply = await message.channel.send(f"Deleted {len(deleted)-1} message(s)!")
                            await deletionReply.delete(delay=1)
                        except:
                            try:
                                await message.reply(embed=createEmbed("Command Error: w!clear", error, red, footer))
                            except:
                                pass
                    else:
                        await message.reply(embed=createEmbed(f"Command Requirements: w!talk", f"Sorry, <@{message.author.id}>. This command requires permission: `Manage Messages`", red, footer))
                elif command == prefix+"mute":
                    if message.author.guild_permissions.kick_members == True:
                        error = "**UNKNOWN ERROR**"
                        mention = getArg(message.content,1)
                        reason = getArg(message.content,[[2, "+"]])
                        if reason == "":
                            reason = "No Reason Given"
                        try:
                            error = f"Invalid Argument 1. Expected `Mention` or `UserId`, got \"{mention}\""
                            if mention == "":
                                Error
                            if mention.isdigit() == False:
                                userId = mention.replace("<@!","")
                                userId = userId.replace(">","")
                            else:
                                userId = mention
                            userId = int(userId)
                            error = "Invalid Mention/UserId. Please mention a member that's in this server."
                            member = await message.guild.fetch_member(userId)
                            if member == None:
                                Error
                            muteRole = None
                            for role in message.guild.roles:
                                if role.name.lower() == "muted":
                                    muteRole = role
                            error = f"Insufficient Permissions to mute {member.name}. Requires permission `Manage Roles`."
                            if muteRole == None:
                                muteRole = await message.guild.create_role(name="Muted", reason=f"Create Mute Role - {message.author.name}")
                            for channel in message.guild.text_channels:
                                await channel.set_permissions(muteRole, send_messages=False)
                            for channel in message.guild.voice_channels:
                                await channel.set_permissions(muteRole, speak=False)
                            await member.add_roles(muteRole, reason=reason)
                            error = f"Unable to DM {member.name}#{member.discriminator}."
                            dm = await member.create_dm()
                            await dm.send(f"You have been muted in **{message.guild.name}** for reason: `{reason}`")
                            await message.reply(f"`{member.name}#{member.discriminator}` has been muted by `{message.author.name}#{message.author.discriminator}` for reason `{reason}`")
                        except:
                            errorReply = await message.reply(embed=createEmbed("Command Error: w!mute", error, red, footer))
                            await errorReply.delete(delay=5)
                    else:
                        await message.reply(embed=createEmbed(f"Command Requirements: w!mute", f"Sorry, <@{message.author.id}>. This command requires permission: `Kick Members`", red, footer))
                elif command == prefix+"unmute":
                    if message.author.guild_permissions.kick_members == True:
                        error = "**UNKNOWN ERROR**"
                        mention = getArg(message.content,1)
                        try:
                            error = f"Invalid Argument 1. Expected `Mention` or `UserId`, got \"{mention}\""
                            if mention == "":
                                Error
                            if mention.isdigit() == False:
                                userId = mention.replace("<@!","")
                                userId = userId.replace(">","")
                            else:
                                userId = mention
                            userId = int(userId)
                            error = "Invalid Mention/UserId. Please mention a member that's in this server."
                            member = await message.guild.fetch_member(userId)
                            if member == None:
                                Error
                            muteRole = None
                            for role in message.guild.roles:
                                if role.name.lower() == "muted":
                                    muteRole = role
                            error = f"Insufficient Permissions to unmute {member.name}. Requires permission `Manage Roles` and bot role to be above the mute role: <@&{muteRole.id}>"
                            if muteRole == None:
                                error = "Please mute a member first, so that I can create the mute role."
                            await member.remove_roles(muteRole)
                            error = f"Unable to DM {member.name}#{member.discriminator}."
                            dm = await member.create_dm()
                            await dm.send(f"You have been unmuted in **{message.guild.name}**")
                            await message.reply(f"`{member.name}#{member.discriminator}` has been unmuted by `{message.author.name}#{message.author.discriminator}`")
                        except:
                            errorReply = await message.reply(embed=createEmbed("Command Error: w!unmute", error, red, footer))
                            await errorReply.delete(delay=5)
                    else:
                        await message.reply(embed=createEmbed(f"Command Requirements: w!unmute", f"Sorry, <@{message.author.id}>. This command requires permission: `Kick Members`", red, footer))
                elif command == prefix+"warn":
                    if message.author.guild_permissions.kick_members == True:
                        error = "**UNKNOWN ERROR**"
                        mention = getArg(message.content,1)
                        reason = getArg(message.content,[[2, "+"]])
                        if reason == "":
                            reason = "No Reason Given"
                        try:
                            error = f"Invalid Argument 1. Expected `Mention` or `UserId`, got \"{mention}\""
                            if mention == "":
                                Error
                            if mention.isdigit() == False:
                                userId = mention.replace("<@!","")
                                userId = userId.replace(">","")
                            else:
                                userId = mention
                            userId = int(userId)
                            error = "Invalid Mention/UserId. Please mention a member that's in this server."
                            member = await message.guild.fetch_member(userId)
                            if member == None:
                                Error
                            error = f"Unable to DM {member.name}#{member.discriminator}."
                            dm = await member.create_dm()
                            await dm.send(f"You have been warned in **{message.guild.name}** by `{message.author.name}#{message.author.discriminator}` for reason: `{reason}`")
                            await message.reply(f"`{member.name}#{member.discriminator}` has been warned.")
                        except:
                            errorReply = await message.reply(embed=createEmbed("Command Error: w!mute", error, red, footer))
                            await errorReply.delete(delay=5)
                    else:
                        await message.reply(embed=createEmbed(f"Command Requirements: w!warn", f"Sorry, <@{message.author.id}>. This command requires permission: `Kick Members`", red, footer))
                elif command == prefix+"kick":
                    if message.author.guild_permissions.kick_members == True:
                        error = "**UNKNOWN ERROR**"
                        mention = getArg(message.content,1)
                        reason = getArg(message.content,[[2, "+"]])
                        if reason == "":
                            reason = "No Reason Given"
                        try:
                            error = f"Invalid Argument 1. Expected `Mention` or `UserId`, got \"{mention}\""
                            if mention == "":
                                Error
                            if mention.isdigit() == False:
                                userId = mention.replace("<@!","")
                                userId = userId.replace(">","")
                            else:
                                userId = mention
                            userId = int(userId)
                            error = "Invalid Mention/UserId. Please mention a member that's in this server."
                            member = await message.guild.fetch_member(userId)
                            if member == None:
                                Error
                            error = f"Insufficient Permissions to Kick {member.name} from this server. Requires permission `Kick Members` and bot role to be above <@{member.id}>'s highest role: <@&{member.roles[len(member.roles)-1].id}>"
                            await member.kick(reason=reason)
                            error = f"Unable to DM {member.name}#{member.discriminator}."
                            dm = await member.create_dm()
                            await dm.send(f"You have been kicked from **{message.guild.name}** by `{message.author.name}#{message.author.discriminator}` for reason: `{reason}`")
                            await message.reply(f"`{member.name}#{member.discriminator}` has been kicked.")
                        except:
                            errorReply = await message.reply(embed=createEmbed("Command Error: w!kick", error, red, footer))
                            await errorReply.delete(delay=5)
                    else:
                        await message.reply(embed=createEmbed(f"Command Requirements: w!kick", f"Sorry, <@{message.author.id}>. This command requires permission: `Kick Members`", red, footer))
                elif command == prefix+"ban":
                    if message.author.guild_permissions.ban_members == True:
                        error = "**UNKNOWN ERROR**"
                        mention = getArg(message.content,1)
                        reason = getArg(message.content,[[2, "+"]])
                        if reason == "":
                            reason = "No Reason Given"
                        try:
                            error = f"Invalid Argument 1. Expected `Mention` or `UserId`, got \"{mention}\""
                            if mention == "":
                                Error
                            if mention.isdigit() == False:
                                userId = mention.replace("<@!","")
                                userId = userId.replace(">","")
                            else:
                                userId = mention
                            userId = int(userId)
                            error = "Invalid Mention/UserId."
                            member = await client.fetch_user(userId)
                            if member == None:
                                Error
                            try:
                                error = f"Insufficient Permissions to Ban {member.name} from this server. Requires permission `Ban Members` and bot role to be above <@{member.id}>'s highest role: <@&{member.roles[len(member.roles)-1].id}>."
                            except:
                                error = f"Insufficient Permissions to Ban {member.name} from this server. Requires permission `Ban Members`."
                            await message.guild.ban(user=member)
                            await message.reply(f"`{member.name}#{member.discriminator}` has been banned.")
                            error = f"Unable to DM {member.name}#{member.discriminator}."
                            dm = await member.create_dm()
                            await dm.send(f"You have been **BANNED** from **{message.guild.name}** by `{message.author.name}#{message.author.discriminator}` for reason: `{reason}`")
                        except:
                            errorReply = await message.reply(embed=createEmbed("Command Error: w!ban", error, red, footer))
                            await errorReply.delete(delay=5)
                    else:
                        await message.reply(embed=createEmbed(f"Command Requirements: w!ban", f"Sorry, <@{message.author.id}>. This command requires permission: `Ban Members`", red, footer))
                elif command == prefix+"unban":
                    if message.author.guild_permissions.ban_members == True:
                        error = "**UNKNOWN ERROR**"
                        userId = getArg(message.content,1)
                        try:
                            error = f"Invalid Argument 1. Expected `UserId`, got \"{userId}\""
                            userId = int(userId)
                            error = "Invalid UserId."
                            member = await client.fetch_user(userId)
                            if member == None:
                                Error
                            error = f"Insufficient Permissions to Unban {member.name} from this server. Requires permission `Ban Members`."
                            await message.guild.unban(user=member)
                            await message.reply(f"`{member.name}#{member.discriminator}` has been unbanned.")
                            error = f"Unable to DM {member.name}#{member.discriminator}."
                            dm = await member.create_dm()
                            await dm.send(f"You have been **UNBANNED** from **{message.guild.name}** by `{message.author.name}#{message.author.discriminator}` for reason: `{reason}`")
                        except:
                            errorReply = await message.reply(embed=createEmbed("Command Error: w!unban", error, red, footer))
                            await errorReply.delete(delay=5)
                    else:
                        await message.reply(embed=createEmbed(f"Command Requirements: w!unban", f"Sorry, <@{message.author.id}>. This command requires permission: `Ban Members`", red, footer))
                elif command == prefix+"announce":
                    if message.author.guild_permissions.manage_messages == True:
                        await message.delete()
                        await message.channel.send(embed=createEmbed(f"Announcement from {message.author.name}#{message.author.discriminator}", getArg(message.content,[[1, "+"]]), green, footer))
                    else:
                        await message.reply(embed=createEmbed(f"Command Requirements: w!announce", f"Sorry, <@{message.author.id}>. This command requires permission: `Manage Messages`", red, footer))
                elif command == prefix+"rules":
                    if message.author.guild_permissions.administrator == True:
                        error = "**UNKNOWN ERROR**"
                        channelMentioned = getArg(message.content,1)
                        ruleChannel = None
                        channelId = 0
                        try:
                            for channel in message.guild.text_channels:
                                if channel.name == "rules":
                                    ruleChannel = channel
                            try:
                                if channelMentioned.isdigit() == False:
                                    channelId = channelMentioned.replace("<#","")
                                    channelId = int(channelId.replace(">",""))
                                else:
                                    channelId = int(channelMentioned)
                            except:
                                channelId = 0
                            print(channelId)
                            print(ruleChannel)
                            if channelId != 0:
                                error = f"Invalid channel mentioned: <#{channelId}> does not exist in this server."
                                print(message.guild)
                                ruleChannel = message.guild.get_channel(channelId)
                                rules = getArg(message.content,[[2, "+"]])
                            elif ruleChannel == None:
                                error = "Could not find #rules channel and no channel was mentioned."
                            else:
                                rules = getArg(message.content,[[1, "+"]])
                            await ruleChannel.send(embed=createEmbed("Rules", rules, yellow, f"Rules by: {message.author.name}#{message.author.discriminator} -- " + footer))
                        except:
                            errorReply = await message.reply(embed=createEmbed("Command Error: w!rules", error, red, footer))
                            await errorReply.delete(delay=5)
                    else:
                        await message.reply(embed=createEmbed(f"Command Requirements: w!rules", f"Sorry, <@{message.author.id}>. This command requires permission: `Administrator`", red, footer))
                elif command == prefix+"talk":
                    if message.author.guild_permissions.manage_messages == True:
                        await message.delete()
                        await message.channel.send(getArg(message.content,[[1, "+"]]))
                    else:
                        await message.reply(embed=createEmbed(f"Command Requirements: w!talk", f"Sorry, <@{message.author.id}>. This command requires permission: `Manage Messages`", red, footer))
            except AssertionError:
                errored = "AssertionError"
            except AttributeError:
                errored = "AttributeError"
            except EOFError:
                errored = "EOFError"
            except FloatingPointError:
                errored = "FloatingPointError"
            except GeneratorExit:
                errored = "GeneratorExit"
            except ImportError:
                errored = "ImportError"
            except KeyError: # Common/User Affected
                errored = "KeyError"
            except KeyboardInterrupt:
                errored = "KeyboardInterrupt"
            except MemoryError: # Common/User Affected
                errored = "MemoryError"
            except NameError: # Common/User Affected
                errored = "NameError"
            except NotImplementedError:
                errored = "NotImplementedError"
            except OSError:
                errored = "OSError"
            except OverflowError:
                errored = "OverflowError"
            except ReferenceError:
                errored = "ReferenceError"
            except RuntimeError: # Common/User Affected
                errored = "RuntimeError"
            except StopIteration:
                errored = "StopIteration"
            except SyntaxError: # Common/User Affected
                errored = "SyntaxError"
            except IndentationError:
                errored = "IndentationError"
            except TabError:
                errored = "TabError"
            except SystemError:
                errored = "SystemError"
            except SystemExit:
                errored = "SystemExit"
            except TypeError: # Common/User Affected
                errored = "TypeError"
            except UnboundLocalError:
                errored = "UnboundLocalError"
            except UnicodeError:
                errored = "UnicodeError"
            except UnicodeEncodeError:
                errored = "UnicodeEncodeError"
            except UnicodeDecodeError:
                errored = "UnicodeDecodeError"
            except UnicodeTranslateError:
                errored = "UnicodeTranslateError"
            except ValueError: # Common/User Affected
                errored = "ValueError"
            except ZeroDivisionError: # Common/User Affected
                errored = "ZeroDivisionError"
            except:
                errored = "UNKNOWN"
            finally:
                if errored != False:
                    await message.reply(embed=createEmbed(f"ERROR", f"Unknown Error, Error Type: `{errored}`.\nPlease contact `Urxpaly45#0001` immediately!", red, footer))

client.run(TOKEN)
