# AMX Mod X Inventory API

## Overview

This repository contains an AMX Mod X plugin that serves as an API for managing player inventories. The primary purpose of this API is to allow other plugins, such as a shop plugin, to interact with player inventories seamlessly. The included sample plugin demonstrates how to use the API to add and manage items in a player's inventory.

## Features

- **Inventory Management API:**
  - `inventory_add` native: Add an item to a player's inventory.
  - `inventory_get_item` native: Check if a player has a specific item in their inventory.

- **Commands:**
  - `/inventory`: Check your inventory.
  - `inventory_delete <name>`: Delete the inventory of a specific player.
  - `inventory_transfer <FROM NAME> <TO NAME>`: Transfer inventory items from one player to another.

## Usage

### Using the Inventory API in Other Plugins

1. **Include the API in your plugin:**
   ```pawn
   #include <amxmodx>
   #include <inventory_api>
   ```

2. **Add an item to a player's inventory:**
   ```pawn
   new playerID = 1; // Replace with the target player's ID
   new itemID = 123; // Replace with the desired item ID
   native_inventory_add(playerID, itemID);
   ```

3. **Check if a player has a specific item:**
   ```pawn
   new playerID = 1; // Replace with the target player's ID
   new itemID = 123; // Replace with the desired item ID
   if (native_inventory_get_item(playerID, itemID)) {
       // Player has the item
   } else {
       // Player does not have the item
   }
   ```
## Contributing

Feel free to contribute to the development of this API or report any issues on GitHub. Pull requests and suggestions are welcome!
