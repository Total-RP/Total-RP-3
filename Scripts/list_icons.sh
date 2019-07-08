#!/usr/bin/env bash
# List of icons to ignore
listIgnore=(6IH_IronHorde_Stone_Base_StonewallEdge \
6OR_Garrison_BlackIron \
6OR_Garrison_BlackIron_Light \
6OR_Garrison_BlackIron_Spec \
6OR_Garrison_ClothRoof \
6OR_Garrison_HangingLeather \
6OR_Garrison_Leatherstraps \
6OR_Garrison_Metaltiles \
6OR_Garrison_OrcWindvane3 \
6OR_Garrison_Roof \
6OR_Garrison_Roof_Darkblend \
6OR_Garrison_Sign \
6OR_Garrison_Stair_01 \
6OR_Garrison_Stonewall \
6OR_Garrison_metalbracket \
6OR_Garrison_metaltrim_02 \
6OR_Garrison_spikes \
Cape_DraenorCraftedCaster_D_01black \
Cape_DraenorCraftedCaster_D_01blue \
Cape_DraenorCraftedCaster_D_01red \
Cape_DraenorRaid_D_01caster_blue \
Cape_DraenorRaid_D_01caster_purple \
Cape_DraenorRaid_D_01caster_red \
THROWN_1H_HARPOON_D_01 \
Thrown_1H_Harpoon_D_01Blue \
Thrown_1H_Harpoon_D_01Bronze \
Thrown_1H_Harpoon_D_01Silver \
Shield_DraenorRaid_D_01Blue \
Shield_DraenorRaid_D_01Green \
Shield_DraenorRaid_D_01Orange \
Shield_DraenorRaid_D_01Purple)

IFS="|";
keys="${listIgnore[*]}";
keys="${keys//|/\\|}";

fileList=$(ls $1 | grep -v "${keys}" | sed s/\.[^\.]*$// | sed -e "s/\(.*\)/	\"\1\",/")
echo "local iconList = {" > ./listfile.txt
echo ${fileList} >> ./listfile.txt
echo "}" >> ./listfile.txt
