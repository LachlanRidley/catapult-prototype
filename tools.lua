local cli = require "cliargs"

cli:set_name "Playdate Dev Tools"

cli
    :command("run", "Runs game on simulator")
    :action(function()
        Run()
    end)

cli
    :command("build-assets", "Convert aseprite to PNG")
    :action(function()
        BuildAssets()
    end)

function Run()
    KillExistingSimulator()
    BuildPdx()
    RunSimulator()
end

function BuildPdx()
    os.execute("pdc source game.pdx")
end

function RunSimulator()
    os.execute("start PlaydateSimulator game.pdx")
end

function KillExistingSimulator()
    os.execute("taskkill /im PlaydateSimulator.exe")
end

function BuildAssets()
    os.execute("Aseprite -b support/spike.aseprite --save-as source/images/spike.png")
    os.execute("Aseprite -b support/slime.aseprite --save-as source/images/slime.png")
end

local args, err = cli:parse()

if not args and err then
    return print(err)
elseif args then
    print('no command')
end
