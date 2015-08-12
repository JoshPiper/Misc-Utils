local props = ents.FindByClass("prop_physics")
for _, prop in pairs(props) do
	prop:Remove()
end
