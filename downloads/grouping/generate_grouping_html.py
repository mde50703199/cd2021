def realA(account):
    # 置入 2a 學員特殊情況轉換
    if account == "40623234":
        return account + "-1"
    elif account[0:3] == "407": 
        return "s" + account
    elif account == "40823112":
        return "a" + account
    elif account == "40823231":
        return account + "-2"
    else:
        return account
        
#print(realA("40823113"))

group = []

with open("w5_b_stage2.txt", encoding="utf-8") as file: 
    content = file.readlines()
for i in range(len(content)):
    data = content[i].rstrip("\n").split("\t")
    group.append(data)

output = ""
seperator = "-"*20 + "<br />"
for i in group[1:]:
    gName = i[0]
    gLeader = realA(i[1])
    gM1 = realA(i[2])
    gM2 = realA(i[3])
    gM3 = realA(i[4])
    try:
        gM4 = realA(i[5])
    except:
        gM4 = ""
    
    
    gLeaderRepo = "<a href='http://github.com/" + gLeader + "/cd2021'>" + gLeader + " repo</a>"
    gLeaderSite = "<a href='http://" + gLeader + ".github.io/cd2021'>" + gLeader +  " site</a>"
    gM1repo = "<a href='http://github.com/" + gM1 + "/cd2021'>" + gM1 + " repo</a>"
    gM1site = "<a href='http://" + gM1 + ".github.io/cd2021'>" + gM1 +  " site</a>"
    gM2repo = "<a href='http://github.com/" + gM2 + "/cd2021'>" + gM2 + " repo</a>"
    gM2site = "<a href='http://" + gM2 + ".github.io/cd2021'>" + gM2 +  " site</a>"
    gM3repo = "<a href='http://github.com/" + gM3 + "/cd2021'>" + gM3 + " repo</a>"
    gM3site = "<a href='http://" + gM3 + ".github.io/cd2021'>" + gM3 +  " site</a>"
    
    gRepo = "<a href='http://github.com/" + gLeader + "/" + gName + "'>" + gName + " repo</a>"
    gSite =  "<a href='http://" + gM1 + ".github.io/" + gName + "'>" + gName +  " site</a>"
    
    output += gRepo + " | " + gSite + " | " + gLeaderRepo + " | " + gLeaderSite + " | " +gM1repo + " | " + gM1site + " | " +gM2repo + " | " + gM2site + " | " +gM3repo + " | " + gM3site
    
    if gM4 != "":
        gM4repo = "<a href='http://github.com/" + gM4 + "/cd2021'>" + gM4 + " repo</a>"
        gM4site = "<a href='http://" + gM4 + ".github.io/cd2021'>" + gM4 +  " site</a>"
        output += " |  " + gM4repo + "| " + gM4site + "<br />" + seperator
    else:
        output += "<br />" + seperator
        
print(output)
