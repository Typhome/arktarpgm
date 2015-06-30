public OnPlayerSpawn(playerid)
{
	if(!p_Logged[playerid]) Kick(playerid);
	return 1;
}