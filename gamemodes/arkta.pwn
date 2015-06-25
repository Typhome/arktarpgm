#include <a_samp>
#include <a_mysql>

#define func%0(%1) forward public%0(%1); public%0(%1)

#define GAMEMODE_NAME   "Arkta Roleplay"
#define GAMEMODE_TEXT   "Arkta RP v0.1"

#define MYSQL_HOST  	"127.0.0.1"
#define MYSQL_USER  	"root"
#define MYSQL_DATABASE  "samp"
#define MYSQL_PASSWORD  ""

enum _playerdata {
	p_ID,
	p_Name[MAX_PLAYER_NAME + 1]
};
new PlayerData[MAX_PLAYERS][_playerdata];

new MySQL;

main()
{
	print("\n----------------------------------");
	print(GAMEMODE_NAME);
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	SetGameModeText(GAMEMODE_TEXT);
    MySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DATABASE, MYSQL_PASSWORD);
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

func reset_PlayerData(playerid)
{
	new x[_playerdata];
	PlayerData[playerid] = x;
}
