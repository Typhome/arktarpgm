public OnPlayerConnect(playerid)
{
	reset_PlayerData(playerid);
	p_Logged[playerid] = false;
	new playername[MAX_PLAYER_NAME + 1];
	GetPlayerName(playerid, playername, sizeof(playername));
	
	printf("PlayerData[%d][p_Registered] = %l", playerid, ( check_player(playerid) ? true : false ));
	
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