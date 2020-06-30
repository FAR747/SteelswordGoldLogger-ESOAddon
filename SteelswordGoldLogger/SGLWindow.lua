local SGL = SteelswordGoldLogger
local classes = SGL.classes
local window = SteelswordGoldLoggerMainWindow
local LogList = {}
local strf = string.format

function SGL.Windowinit()
    window:GetNamedChild("UserName"):SetText(SGL.Currectuser.charName..SGL.Currectuser.userid) --
    SGL.addonGUI.transactions = window:GetNamedChild("DetailPanel"):GetNamedChild("SGLItemList")
    SGL.addonGUI.days = window:GetNamedChild("DetailPanel"):GetNamedChild("SGLItemListDay") -- day list 
    SGL.addonGUI.bank = window:GetNamedChild("DetailPanel"):GetNamedChild("SGLItemBankListDay") -- bank list
    ZO_ScrollList_AddDataType(SGL.addonGUI.transactions,1,"SteelswordGoldLoggerLOGITEM",30, function(control,data) SGL.UPDListData(control,data) end)
    ZO_ScrollList_AddDataType(SGL.addonGUI.days,1,"SteelswordGoldLoggerLOGITEM",30, function(control,data) SGL.UPDListData(control,data) end)
    ZO_ScrollList_AddDataType(SGL.addonGUI.bank,1,"SteelswordGoldLoggerLOGITEM",30, function(control,data) SGL.UPDListData(control,data) end)
    SGL.UPDWindowEv()
end
function SGL.UPDListData(control,data)
    control:GetNamedChild("NameLabel"):SetText(data.name)
    control:GetNamedChild("DTLabel"):SetText(data.date)
    local goldstr = ZO_CurrencyControl_FormatCurrencyAndAppendIcon(data.price, false, CURT_MONEY, false)
    local goldcolor
    if data.price >= 0 then
        goldcolor = "|c33FF00"..goldstr.."|r"
        else
        goldcolor = "|cf11100"..goldstr.."|r"    
        end
    control:GetNamedChild("PriceLabel"):SetText(goldcolor)
end
function SGL.UPDWindowEv()
    local date = GetDateStringFromTimestamp(GetTimeStamp()) 
    local time = GetTimeString()
    local str0 = date.." "..time
    local str = strf(GetString(SI_SGL_MW_LASTUPDTIME), str0)
    window:GetNamedChild("LastUPDTime"):SetText(str)

    local buttonBank = window:GetNamedChild("ButtonBankSwitchlist")
    buttonBank:SetHidden(SGL.savedVars.hidebankbutton)
end
function SGL.setcurrectgold(gold)
    local goldstr = ZO_CurrencyControl_FormatCurrencyAndAppendIcon(gold, false, CURT_MONEY, false)
    if SteelswordGoldLogger.savedVars.hidecurrectgold then
        goldstr = "******"
    end
    local str = strf(GetString(SI_SGL_MW_CURRECTGOLD), goldstr)
    window:GetNamedChild("CurrectGoldLabel"):SetText(str)
end
function SGL.setsessiongold(gold)
    local goldcolor
    local goldstr = ZO_CurrencyControl_FormatCurrencyAndAppendIcon(gold, false, CURT_MONEY, false)
    if gold >= 0 then
        goldcolor = "|c33FF00"..goldstr.."|r"
        else
        goldcolor = "|cf11100"..goldstr.."|r"    
        end
    local str = strf(GetString(SI_SGL_MW_SESSIONGOLD), goldcolor)
    window:GetNamedChild("SessionGoldLabel"):SetText(str)
end
function SGL.setdaygold(gold)
    local goldcolor
    local goldstr = ZO_CurrencyControl_FormatCurrencyAndAppendIcon(gold, false, CURT_MONEY, false)
    if gold >= 0 then
        goldcolor = "|c33FF00"..goldstr.."|r"
        else
        goldcolor = "|cf11100"..goldstr.."|r"    
        end
    local str = strf(GetString(SI_SGL_MW_DAYGOLD), goldcolor)
    window:GetNamedChild("DayGoldLabel"):SetText(str)
end

function SGL.Switchlistonwindow()
    local buttonlabel = window:GetNamedChild("ButtonSwitchlist"):GetNamedChild("ButtonSwitchlistLabel")
    local buttonBank = window:GetNamedChild("ButtonBankSwitchlist")
    local tpanel = window:GetNamedChild("DetailPanel"):GetNamedChild("SGLItemList")
    local dpanel = window:GetNamedChild("DetailPanel"):GetNamedChild("SGLItemListDay")--DetailPanelDays
    local bpanel =  window:GetNamedChild("DetailPanel"):GetNamedChild("SGLItemBankListDay") -- bank list
    --buttonlabel:SetText("OK!")
    if SteelswordGoldLogger.Temps.isdaylogsinlist then
        -- load T logs
        SteelswordGoldLogger.Temps.isdaylogsinlist = false
        buttonlabel:SetText(GetString(SI_SGL_MW_SWITCH_DAYS))
        tpanel:SetHidden(false)
        dpanel:SetHidden(true)
        bpanel:SetHidden(true)
    else
        -- load D logs
        SteelswordGoldLogger.Temps.isdaylogsinlist = true
        buttonlabel:SetText(GetString(SI_SGL_MW_SWITCH_TLOG))
        tpanel:SetHidden(true)
        dpanel:SetHidden(false)
        bpanel:SetHidden(true)
    end
    
    if SteelswordGoldLogger.Temps.isbanklogsinlist then
        buttonBank:SetHidden(false)
        SGL.UPDWindowEv()
        SGL.MW_WarningMessageUPD(true,"nil")
    end
end

function SGL.SwitchtoBankList()
    local buttonlabel = window:GetNamedChild("ButtonSwitchlist"):GetNamedChild("ButtonSwitchlistLabel")
    local buttonBank = window:GetNamedChild("ButtonBankSwitchlist")
    local tpanel = window:GetNamedChild("DetailPanel"):GetNamedChild("SGLItemList")
    local dpanel = window:GetNamedChild("DetailPanel"):GetNamedChild("SGLItemListDay")--DetailPanelDays
    local bpanel =  window:GetNamedChild("DetailPanel"):GetNamedChild("SGLItemBankListDay") -- bank list
    
    buttonlabel:SetText(GetString(SI_SGL_MW_SWITCH_TLOG))
    tpanel:SetHidden(true)
    dpanel:SetHidden(true)
    bpanel:SetHidden(false)
    buttonBank:SetHidden(true)
    SteelswordGoldLogger.Temps.isdaylogsinlist = true
    SteelswordGoldLogger.Temps.isbanklogsinlist = true
    if not SGL.Temps.bank.isfirstsesstionbankupd then
    SGL.WARNINGMESSAGE_SetBankUPDMessage()
    end
end

function SGL.MW_WarningMessageUPD(hidden, message)
    local warningmessageLabel = window:GetNamedChild("WarningMessage")
    warningmessageLabel:SetHidden(hidden)
    warningmessageLabel:SetText(message)
end