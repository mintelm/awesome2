local awful = require('awful')
local naughty = require('naughty')

local auto_start = {}

function auto_start.run_once(cmd)
    local binary = cmd
    local firstspace = cmd:find(' ')

    if firstspace then
        binary = cmd:sub(0, firstspace - 1)
    end

    awful.spawn.easy_async_with_shell(
        -- if no process with binary exists, start command
        string.format('pgrep -u $USER -x %s > /dev/null || (%s)', binary, cmd),
        function(stdout, stderr)
            -- Debugger 
            if not stderr or stderr == '' then
                return 
            end
            naughty.notification({
                app_name = 'Start-up Applications',
                title = '<b>Oof! Error detected when starting an application!</b>',
                message = stderr:gsub('%\n', ''),
                timeout = 20,
                icon = require('beautiful').awesome_icon
            })
        end
    )
end

return auto_start
