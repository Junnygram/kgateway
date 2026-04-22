local hs = { status = "Progressing", message = "Waiting for resource to be accepted" }
if obj.status == nil or obj.status.conditions == nil then
  hs.status = "Healthy"
  hs.message = "Resource exists (status not implemented)"
  return hs
end
for i, condition in ipairs(obj.status.conditions) do
  if condition.type == "Accepted" then
    if condition.status == "True" then
      hs.status = "Healthy"
      hs.message = condition.message
      return hs
    end
    if condition.status == "False" then
      hs.status = "Degraded"
      hs.message = condition.message
      return hs
    end
  end
end
return hs
