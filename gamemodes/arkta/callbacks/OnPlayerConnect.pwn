public OnPlayerConnect(playerid)
{
	TogglePlayerSpectating(playerid, true);
	reset_PlayerData(playerid);
	p_Logged[playerid] = false;
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	strcpy(PlayerData[playerid][p_Name], playername, MAX_PLAYER_NAME);
	printf("PlayerData[%d][p_Name] = %s", playerid, PlayerData[playerid][p_Name]);
	
	printf("PlayerData[%d][p_Registered] = %d", playerid, ( check_player(playerid) ? true : false ));
	
	PlayerData[playerid][p_Registered] = ( check_player(playerid) ? true : false );

	if (PlayerData[playerid][p_Registered])
	{
		new qstring[128];
		mysql_format(MySQL, qstring, sizeof(qstring), "SELECT `id`, `password` FROM "DB_USERS" WHERE `username` = '%e' LIMIT 1", playername);
		mysql_tquery(MySQL, qstring, "OnPlayerDataCheck", "i", playerid);
	}
	else
	{
		//
	}
	
	return 1;
}