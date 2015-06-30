#include <a_samp>
#include <string>
#include <a_mysql>
#include <colors>
#include <easyDialog>

#define function%0(%1) forward public%0(%1); public%0(%1)
#define strcpy(%0,%1,%2) \
    strcat((%0[0] = '\0', %0), %1, %2)

#define GAMEMODE_NAME   "Arkta Roleplay"
#define GAMEMODE_TEXT   "Arkta RP v0.1"
#define SERVER_MAP		"San Andreas"
#define SERVER_LANGUAGE "English"

#define MYSQL_HOST  	"127.0.0.1"
#define MYSQL_USER  	"root"
#define MYSQL_DATABASE  "samp"
#define MYSQL_PASSWORD  ""

#define DB_USERS    "users"

enum _playerdata {
	p_ID,
	p_Name[MAX_PLAYER_NAME + 1],
	p_Password[128 + 1],
	bool:p_Registered,
	p_Skin,
	p_Money,
	Float:p_Pos[3],
	Float:p_Angle,
	p_Guns[13],
	p_Ammos[13]
};
new PlayerData[MAX_PLAYERS][_playerdata];

new bool:p_Logged[MAX_PLAYERS];

new MySQL;

main() {}

public OnGameModeInit()
{
    print(GAMEMODE_NAME);
    SendRconCommand("mapname "SERVER_MAP);
	SendRconCommand("language "SERVER_LANGUAGE);
	SetGameModeText(GAMEMODE_TEXT);
	DisableInteriorEnterExits();
   	ShowPlayerMarkers(1);
	ShowNameTags(1);
	EnableStuntBonusForAll(0);
	SetNameTagDrawDistance(25);
    ManualVehicleEngineAndLights();
    SetGravity(0.01);
    MySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DATABASE, MYSQL_PASSWORD);
    if(mysql_errno(MySQL) != 0)
	{
		print("MySQL connection is dead!");
        SendRconCommand("exit"); // Shutting server down because of MySQL connection failure!
        return 1;
	}
	printf("MySQL connection is ready.");
	mysql_log(LOG_ALL, LOG_TYPE_HTML);
	return 1;
}

public OnGameModeExit()
{
    mysql_close(MySQL);
	return 1;
}

#include "arkta/callbacks/OnRequestClass.pwn"
#include "arkta/callbacks/OnPlayerConnect.pwn"
#include "arkta/callbacks/OnPlayerDisconnect.pwn"
#include "arkta/callbacks/OnPlayerSpawn.pwn"
#include "arkta/callbacks/OnPlayerDeath.pwn"
#include "arkta/callbacks/OnVehicleSpawn.pwn"
#include "arkta/callbacks/OnVehicleDeath.pwn"
#include "arkta/callbacks/OnPlayerText.pwn"
#include "arkta/callbacks/OnPlayerCommandText.pwn"
#include "arkta/callbacks/OnPlayerEnterVehicle.pwn"
#include "arkta/callbacks/OnPlayerExitVehicle.pwn"
#include "arkta/callbacks/OnPlayerStateChange.pwn"
#include "arkta/callbacks/OnPlayerEnterCheckpoint.pwn"
#include "arkta/callbacks/OnPlayerLeaveCheckpoint.pwn"
#include "arkta/callbacks/OnPlayerEnterRaceCheckpoint.pwn"
#include "arkta/callbacks/OnPlayerLeaveRaceCheckpoint.pwn"
#include "arkta/callbacks/OnPlayerRequestSpawn.pwn"
#include "arkta/callbacks/OnObjectMoved.pwn"
#include "arkta/callbacks/OnPlayerObjectMoved.pwn"
#include "arkta/callbacks/OnPlayerPickUpPickup.pwn"
#include "arkta/callbacks/OnVehicleMod.pwn"
#include "arkta/callbacks/OnVehiclePaintjob.pwn"
#include "arkta/callbacks/OnVehicleRespray.pwn"
#include "arkta/callbacks/OnPlayerSelectedMenuRow.pwn"
#include "arkta/callbacks/OnPlayerExitedMenu.pwn"
#include "arkta/callbacks/OnPlayerInteriorChange.pwn"
#include "arkta/callbacks/OnPlayerKeyStateChange.pwn"
#include "arkta/callbacks/OnRconLoginAttempt.pwn"
#include "arkta/callbacks/OnPlayerUpdate.pwn"
#include "arkta/callbacks/OnPlayerStreamIn.pwn"
#include "arkta/callbacks/OnPlayerStreamOut.pwn"
#include "arkta/callbacks/OnVehicleStreamIn.pwn"
#include "arkta/callbacks/OnVehicleStreamOut.pwn"
#include "arkta/callbacks/OnDialogResponse.pwn"
#include "arkta/callbacks/OnPlayerClickPlayer.pwn"

public OnDialogPerformed(playerid, dialog[], response, success)
{
    return 1;
}

Dialog:dialog_login(playerid, response, listitem, inputtext[])
{
    if (response)
    {
		if (!strcmp(inputtext, PlayerData[playerid][p_Password]))
		{
		    // Password is correct!
		    p_Logged[playerid] = true;
		    new qstring[128];
			mysql_format(MySQL, qstring, sizeof(qstring), "SELECT * FROM "DB_USERS" WHERE `username` = '%e' LIMIT 1", PlayerData[playerid][p_Name]);
			mysql_tquery(MySQL, qstring, "OnPlayerDataLoad", "i", playerid);
		}
		else
		{
		    // Incorrect password!
		    return ShowPlayerLogin(playerid, true);
		}
    }
    else Kick(playerid);
    return 1;
}

Dialog:dialog_register(playerid, response, listitem, inputtext[])
{
    if (response)
    {
		if (!strlen(inputtext))
		{
			strmid(PlayerData[playerid][p_Password], inputtext, 0, strlen(inputtext), 128 + 1);
			PlayerData[playerid][p_Registered] = true;
			return ShowPlayerLogin(playerid);
		}
		else
		{
			return ShowPlayerRegister(playerid);
		}
	}
    else Kick(playerid);
    return 1;
}

function KickTimer(playerid)
{
    Kick(playerid);
	return 1;
}

stock _Kick(playerid)
{
	SetTimerEx("KickTimer", 100, false, "i", playerid);
	return 1;
}

#if defined _ALS_Kick
	#undef Kick
#else
	#define _ALS_Kick
#endif
#define Kick _Kick

function reset_PlayerData(playerid)
{
	new x[_playerdata];
	PlayerData[playerid] = x;
}

function check_player(playerid)
{
	new playername[MAX_PLAYER_NAME + 1], qstring[128];
	GetPlayerName(playerid, playername, sizeof(playername));
	mysql_format(MySQL, qstring, sizeof(qstring), "SELECT count(id) FROM "DB_USERS" WHERE `username` = '%e'", playername);
	new Cache:result = mysql_query(MySQL, qstring);
	new rows = cache_num_rows();
	cache_delete(result);
	if (rows)
	{
		return 1; // Player record exists.
	}
	return 0; // Player record does not exist.
}

function save_player(playerid)
{
	if(check_player(playerid))
	{
		//
	}
	return 0; // Player record does not exist.
}

function OnPlayerDataCheck(playerid)
{
	new
		rows,
		fields
	;
	cache_get_data(rows, fields, MySQL);
	if(rows)
	{
	    PlayerData[playerid][p_ID] = cache_get_field_content_int(0, "id");
	    cache_get_field_content(0, "password", PlayerData[playerid][p_Password], MySQL, 128 + 1);
		ShowPlayerLogin(playerid);
	}
	else
	{
	    ShowPlayerRegister(playerid);
	}
	return 1;
}

function OnPlayerDataLoad(playerid)
{
    new
		rows,
		fields
	;
	cache_get_data(rows, fields, MySQL);
	if(rows)
	{
	    SendClientMessage(playerid, -1, "Loading your data...");
	
	    PlayerData[playerid][p_ID] = cache_get_field_content_int(0, "id");
	
		PlayerData[playerid][p_Pos][0] = cache_get_field_content_float(0, "pos_X");
		PlayerData[playerid][p_Pos][1] = cache_get_field_content_float(0, "pos_Y");
		PlayerData[playerid][p_Pos][2] = cache_get_field_content_float(0, "pos_Z");
		PlayerData[playerid][p_Angle] = cache_get_field_content_float(0, "angle");
		
		PlayerData[playerid][p_Money] = cache_get_field_content_int(0, "money");
		PlayerData[playerid][p_Skin] = cache_get_field_content_int(0, "skin");
		
		SendClientMessage(playerid, -1, "Your data is loaded.");
		
		player_spawn(playerid);
  	}
	else
	{
	    Kick(playerid);
	}
	return 1;
}

stock ShowPlayerLogin(playerid, bool:wrong = false)
{
	if(wrong == true) return Dialog_Show(playerid, dialog_login, DIALOG_STYLE_PASSWORD, "Login", "Wrong password!\nEnter again your password below:", "Login", "Cancel");
	return Dialog_Show(playerid, dialog_login, DIALOG_STYLE_PASSWORD, "Login", "Enter your password below:", "Login", "Cancel");
}

stock ShowPlayerRegister(playerid)
{
	return Dialog_Show(playerid, dialog_register, DIALOG_STYLE_PASSWORD, "Login", "Enter your new password below:", "Register", "Cancel");
}

function player_unfreeze(playerid)
{
	return TogglePlayerControllable(playerid, true);
}

function player_freeze(playerid)
{
    return TogglePlayerControllable(playerid, false);
}

function player_spawn(playerid)
{
	// stuff
    TogglePlayerSpectating(playerid, false);
    return 1;
}

function player_clearchat(playerid)
{
	for(new i; i < 20; i++) SendClientMessage(playerid, -1, " ");
}
