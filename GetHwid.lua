local ExecutorRequestFunc = nil
if syn then
	ExecutorRequestFunc = syn.request
elseif http then
	ExecutorRequestFunc = http.request
elseif request then
	ExecutorRequestFunc = request
else
	ExecutorRequestFunc = nil
end

if not ExecutorRequestFunc then
	return rconsoleerr("Unsupport exploit (should support syn.request or http.request)")
end

local headers = game:GetService("HttpService").JSONDecode(
	game:GetService("HttpService"),
	ExecutorRequestFunc({
		Url = "http://httpbin.org/post",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
		},
		Body = game:GetService("HttpService").JSONEncode(game:GetService("HttpService"), { hello = "world" }),
	})["Body"]
)["headers"]
if headers["Syn-User-Identifier"] then
	_G.HWID = headers["Syn-User-Identifier"]
elseif headers["Krnl-Hwid"] then
	_G.HWID = headers["Krnl-Hwid"]
elseif headers["Sw-User-Identifier"] then
	_G.HWID = headers["Sw-User-Identifier"]
else
	_G.HWID = nil
end

if not _G.HWID then
    if rconsoleerr then
		rconsoleerr("Unable to get hwid, please report this in our discord")
	elseif messagebox then
		messagebox("Unable to get hwid, please report this in our discord")
	else
		error("unable to get hwid lol")
	end
end

setclipboard(_G.HWID)
messagebox("Copied HWID to clipboard")
