--Guard with Eyes of Blue
--By: HelixReactor
function c72001812.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c72001812.sptg)
	e1:SetOperation(c72001812.spop)
	c:RegisterEffect(e1)
	--To grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,72001812)
	e2:SetTarget(c72001812.gvtg)
	e2:SetOperation(c72001812.gvop)
	c:RegisterEffect(e2)
end
function c72001812.spfilter1(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72001812.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72001812.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c72001812.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72001812.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c72001812.gvfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToGrave()
end
function c72001812.spfilter2(c,e,tp)
	return c:IsSetCard(0xd8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72001812.gvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c72001812.gvfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c72001812.gvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c72001812.gvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0)
end
function c72001812.gvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c72001812.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c72001812.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end