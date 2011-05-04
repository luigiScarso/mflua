print("······· mflua_main_control says: 'Hello world!' ·······")

function PRE_main_control()
 print("······· PRE_main_control says: 'Hello world!' ·······")
 return 0
end

function POST_main_control()
 print("······· POST_main_control says: 'Hello world!' ·······")
 return 0
end
