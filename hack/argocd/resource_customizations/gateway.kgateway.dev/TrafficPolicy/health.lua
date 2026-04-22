local hs = { status = "Progressing", message = "Waiting for policy to be accepted by ancestors" }
if obj.status ~= nil and obj.status.ancestors ~= nil and #obj.status.ancestors > 0 then
  local all_accepted = true
  local any_rejected = false
  local message = ""
  for i, ancestor in ipairs(obj.status.ancestors) do
    local accepted = false
    if ancestor.conditions ~= nil then
      for j, condition in ipairs(ancestor.conditions) do
        if condition.type == "Accepted" then
          if condition.status == "True" then
            accepted = true
          elseif condition.status == "False" then
            any_rejected = true
            message = "Rejected by ancestor: " .. (condition.message or "unknown reason")
          end
        end
      end
    end
    if not accepted then
      all_accepted = false
    end
  end
  
  if any_rejected then
    hs.status = "Degraded"
    hs.message = message
    return hs
  end
  
  if all_accepted then
    hs.status = "Healthy"
    hs.message = "Policy accepted by all ancestors"
    return hs
  end
end
return hs
