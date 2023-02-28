local TRP3_API = select(2, ...);

TRP3_API.Ellyb = {};

-- Temporary; will be removed once all internal logging in Ellyb is ripped out.

function TRP3_API.Ellyb.Log(...)
	if TRP3_API.Log then
		TRP3_API.Log(...);
	end
end

function TRP3_API.Ellyb.Logf(...)
	if TRP3_API.Logf then
		TRP3_API.Logf(...);
	end
end
