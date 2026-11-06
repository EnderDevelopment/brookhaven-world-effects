# Roblox House Map Admin Script

A Roblox server script for a house map that adds admin commands to pull other players nearby, create visual explosions at tagged tanks, hide or show the admin character, and change the skybox using a Roblox image asset ID.

## Install

1. Open the place in Roblox Studio.
2. In Explorer, open `ServerScriptService` and create a normal `Script` named `HouseMapAdmin`.
3. Copy the code from `ServerScriptService/HouseMapAdmin.server.lua` into the new Script.
4. Add trusted Roblox user IDs to the `ADMIN_USER_IDS` table in the script.
5. To enable tank explosions, tag each tank Model or main Part with the CollectionService tag `ExplodableTank`.
6. To set a default sky image, enter its numeric asset ID in `SKYBOX_IMAGE_ID`.

## Use

1. Start the place and type commands in Roblox chat using an account whose user ID is in `ADMIN_USER_IDS`.
2. Use `!pullall` to move every other player with a character root part near the admin.
3. Use `!explode` to create a visual explosion at each tagged tank in Workspace.
4. Use `!hide` to hide the admin character and `!show` to restore saved transparency values.
5. Use `!sky 123456789` to set all six skybox faces to an image asset, or use `!sky` to apply the configured default image ID.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/53ded408-3ea7-4c07-8a05-12d4fd73bdd9?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=53ded408-3ea7-4c07-8a05-12d4fd73bdd9
