--真竜の黙示録
--Apocalypse of the True Dracos
--Script by mercury233
function c100912070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c100912070.target)
	c:RegisterEffect(e1)
	--destory and atk & def down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100912070,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100912070)
	e2:SetCondition(c100912070.atkcon)
	e2:SetCost(c100912070.cost)
	e2:SetTarget(c100912070.atktg)
	e2:SetOperation(c100912070.atkop)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100912070,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100912170)
	e3:SetCondition(c100912070.sumcon)
	e3:SetCost(c100912070.cost)
	e3:SetTarget(c100912070.sumtg)
	e3:SetOperation(c100912070.sumop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100912070,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,100912270)
	e4:SetCondition(c100912070.descon)
	e4:SetTarget(c100912070.destg)
	e4:SetOperation(c100912070.desop)
	c:RegisterEffect(e4)
end
function c100912070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c100912070.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	local b1=c100912070.atkcon(e,tp,eg,ep,ev,re,r,rp) and c100912070.atktg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c100912070.sumcon(e,tp,eg,ep,ev,re,r,rp) and c100912070.sumtg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(100912070,0),aux.Stringid(100912070,1))
		elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(100912070,0))
		else op=Duel.SelectOption(tp,aux.Stringid(100912070,1))+1 end
		if op==0 then
			e:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e:SetOperation(c100912070.atkop)
			c100912070.atktg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetCategory(CATEGORY_SUMMON)
			e:SetProperty(0)
			e:SetOperation(c100912070.sumop)
			c100912070.sumtg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c100912070.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c100912070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
end
function c100912070.tgfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1f9) or c:IsCode(30539496,34079868,82321037,87765315,96746083))
end
function c100912070.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c100912070.tgfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c100912070.tgfilter,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetFlagEffect(tp,100912070)==0 end
	Duel.RegisterFlagEffect(tp,100912070,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100912070.tgfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100912070.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc2=g:GetFirst()
		while tc2 do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(math.ceil(tc2:GetAttack()/2))
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc2:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(math.ceil(tc2:GetDefense()/2))
			tc2:RegisterEffect(e2)
			tc2=g:GetNext()
		end
	end
 end
function c100912070.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c100912070.sumfilter(c)
	return (c:IsSetCard(0x1f9) or c:IsCode(30539496,34079868,82321037,87765315,96746083)) and c:IsSummonable(true,nil,1)
end
function c100912070.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100912070.sumfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetFlagEffect(tp,100912170)==0 end
	Duel.RegisterFlagEffect(tp,100912170,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c100912070.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c100912070.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function c100912070.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c100912070.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100912070.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
