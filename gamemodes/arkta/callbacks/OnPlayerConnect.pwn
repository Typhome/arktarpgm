public OnPlayerConnect(playerid)
{
	reset_PlayerData(playerid);
	new playername[MAX_PLAYER_NAME + 1];
	GetPlayerName(playerid, playername, sizeof(playername));
	return 1;
}