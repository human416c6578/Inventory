#include <amxmodx>
#include <nvault>

new g_iVault;

new Array:inventory[33];

public plugin_init()
{
	register_clcmd("say /inventory", "CheckInventory");
	register_clcmd("inventory_delete", "DeleteInventoryCMD", ADMIN_IMMUNITY, "inventory_delete <name>");
	register_clcmd("inventory_transfer", "TransferInventory", ADMIN_IMMUNITY, "inventory_transfer <FROM NAME> <TO NAME>");
	g_iVault = nvault_open("inventory");
}

public plugin_end(){
	nvault_close(g_iVault);
}

public CheckInventory(id){
	for(new i;i<ArraySize(inventory[id]);i++){
		new tempItem = ArrayGetCell(inventory[id], i);
		client_print(id, print_chat, "%d", tempItem);
			
	}
}

public plugin_natives()
{
	register_library("inventory");

	register_native("inventory_add", "native_inventory_add");
	register_native("inventory_get_item", "native_inventory_get_item");
}

public native_inventory_add(numParams)
{
	new id = get_param(1);
	new item = get_param(2);

	if(!is_user_connected(id)) return PLUGIN_CONTINUE;

	ArrayPushCell(inventory[id], item);
	/*
		new szName[64];
		get_user_name(id, szName, 63);
		server_print("Add %d to  %s's inventory", item, szName);
	*/
	return PLUGIN_CONTINUE;
}

public native_inventory_get_item(numParams)
{
	new id = get_param(1);
	if(!is_user_connected(id)) return false;

	new item = get_param(2);
	if(!item)
		return false;
	static tempItem = 0;
	for(new i;i<ArraySize(inventory[id]);i++){
		tempItem = ArrayGetCell(inventory[id], i);
		if(item == tempItem){
			return true;
		}
			
	}
	return false;
}

public client_putinserver(id)
{
	inventory[id] = ArrayCreate();
	LoadInventory(id);
}

public client_disconnected(id)
{
	if(is_user_connected(id)){
		SaveInventory(id);
		ArrayDestroy(inventory[id]);
	}
	
}

public TransferInventory(id)
{
	new szName[64], szName2[64];
	new data[256];
	new timestamp;
	read_argv(1, szName, 63);
	read_argv(2, szName2, 63);
	server_print(szName);
	server_print(szName2);

	new player1 = isUserConnected(szName);
	new player2 = isUserConnected(szName2);
	if(player1 != -1)
	{
		SaveInventory(player1);
	}

	if(nvault_lookup( g_iVault, szName, data, sizeof( data ) - 1, timestamp))
	{
		nvault_set(g_iVault, szName2, data);
		if(player2 != -1)
		{
			inventory[player2] = ArrayCreate();
			LoadInventory(player2);
		}
		DeleteInventory(szName);
	}

	return PLUGIN_HANDLED;
}

public DeleteInventoryCMD(id){
	new szName[64];
	read_argv(1, szName, 63);

	DeleteInventory(szName);

	return PLUGIN_HANDLED;
}

public DeleteInventory(szName[])
{
	nvault_set( g_iVault, szName, "" );
	new player = isUserConnected(szName)
	if(player != -1){
		ArrayDestroy(inventory[player]);
		inventory[player] = ArrayCreate();
	}
}

public LoadInventory(id)
{
	new szName[64];
	new data[256];
	new timestamp;
	get_user_name(id, szName, 63);
	nvault_get(g_iVault, szName, data, sizeof(data) - 1);
	

	if (nvault_lookup(g_iVault, szName, data, charsmax(data), timestamp)){
			ParseLoadData(id, data);
	} else {
		server_print("No data matching ^"%s^"", szName);
	}
}

public SaveInventory(id)
{
	new num;
	new szName[64];
	new data[512];
	new len;
	get_user_name(id, szName, 63);
	for(new i = 0; i < ArraySize(inventory[id]); i++)
	{
		num = ArrayGetCell(inventory[id], i);
		len += formatex( data[ len ], sizeof( data ) - len - 1, " %d", num );
	}
	nvault_set( g_iVault, szName, data )
}

ParseLoadData(id, data[256])
{
	new num[6]
	while(strlen(data) > 1){
		argbreak( data, num, sizeof( num ) - 1, data, sizeof( data ) - 1 )
		ArrayPushCell(inventory[id], str_to_num(num));
	}	
}

stock isUserConnected(szName[])
{
	new players[32], iNum;
	get_players(players, iNum);
	new tempName[64];
	for(new i;i<iNum;i++){
		get_user_name(players[i], tempName, 63);
		if(equali(szName, tempName))
			return players[i];
	}
	return -1;
}
