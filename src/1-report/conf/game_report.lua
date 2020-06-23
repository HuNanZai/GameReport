local rabbitmq = require("resty.rabbitmqstomp")
local cjson = require("cjson")

local opts = {
    username = 'game',
    password = 'game',
    vhost = '/'
}

local mq, err = rabbitmq:new(opts)

if not mq then
    ngx.say('cannot new mq' .. err)
    return
end

mq:set_timeout(10000)

local HOST = "game-mq"
local PORT = "61613"
local ok, err = mq:connect(HOST, PORT)
if not ok then
    ngx.say('cannot connect mq err:' .. err)
    return
end
ngx.log(ngx.INFO, "Connect: " .. "OK")

-- 获取请求数据 直接写入rabbitmq
ngx.req.read_body()
local req_data_str = ngx.req.get_body_data()

-- 代码参考 http://www.dahouduan.com/2017/12/07/lua-stomp-rabbitmq/
local headers = {}
headers["destination"] = "/exchange/game_exchange/game"
headers["persistent"] = "true"
headers["content-type"] = "application/json"

local ok, err = mq:send(req_data_str, headers)
if not ok then
    ngx.say('cannot send mq err:' .. err)
    return
end

-- 持久化
local ok, err = mq:set_keepalive(10000, 500)
if not ok then
    ngx.say("mq set keepalive err:" .. err)
    return
end
