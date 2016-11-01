--
-- Virtuajdr dice roller for TS3 by dryas & thi121
--

local function onTextMessageEvent(serverConnectionHandlerID, targetMode, toID, fromID, fromName, fromUniqueIdentifier, message, ffIgnored)
--#################################################################
--#          CONFIG                                               #
--#################################################################

-- constante de traduction
	local jet="lance"
	local lang = os.getenv("dicerollerlang")
	if lang == "FR" then
	jet="lance"
	elseif lang== "EN" then
	jet="roll"
	else
	jet="lance"
	end
--nombre de dés max
	local max_dice = 25
-- debug on 1 off 0
	local debug = 0
	
--#################################################################
--#        SCRIPT                                                 #
--#################################################################
	
	
--Ne pas modifier ce qui suit si vous ne savez pas ce que vous faites ;-)
	tschan = ts3.getChannelOfClient(serverConnectionHandlerID, fromID)

	--la commande doit commencer par (
	if string.sub(message,1,1)=="(" then
		--la commande doit contenir )
		local epos = string.find(message,")")
		if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#epos#"..epos.."#", tschan) end
	if epos~=nil then
			-- la commande doit contenir d
			local dpos = string.find(message,"d")
			if dpos~=nil then
				--verification du nombre de jet
				if dpos>=2 and dpos<=4 then
					--le nombre doit être un nombre
					local nb_jet = 1
					if dpos > 2 then
						nb_jet = tonumber(string.sub(message,2,dpos-1))
						if nb_jet == 0 then
							nb_jet = 1
						end
					end
					if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#dpos#"..dpos.."#", tschan) end
					--le nombre de jet ne doit pas exceder le max_dice
					if nb_jet > max_dice then
						nb_jet = max_dice
					end
					if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#nb_jet#"..nb_jet.."#", tschan) end
					--verification de la presence d'un modificateur
					local mpos = 0
					mpos = string.find(message,"[%+%-]")
                    local mpos2 =0
					local modificateur_type = "+"
					local modificateur_val = 0
                    local modificateur_somme_val = 0
                    local modificateur_somme_type = "+"
					--si modificateur de type (4d6+m)
					if mpos~=nil and mpos<epos then
						modificateur_type=string.sub(message,mpos,mpos)
						modificateur_val= tonumber (string.sub(message,mpos+1,epos-1))
						mpos2 = string.find(message,"[%+%-]",mpos+1)
						if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#(4d6+m)#", tschan) end
					end
					-- si modificateur de type (4d6)+m
					if mpos~=nil and mpos>epos then
                        modificateur_somme_type=string.sub(message,mpos,mpos)
                        modificateur_somme_val= tonumber (string.sub(message,mpos+1))
						mpos2=mpos
						mpos=0
						if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#(4d6)+m#", tschan) end		
                    end
					-- si modificateur de type (4d6+m)+m
					if mpos2~=nil and mpos2>epos and mpos~=0 then
                        modificateur_somme_type=string.sub(message,mpos,mpos)
                        modificateur_somme_val= tonumber (string.sub(message,mpos2+1)) 
						if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#(4d6+m)+m#", tschan) end
                    end
					--si pas de modificateur
					if mpos==nil then
                        mpos = 0
						modificateur_type="+"
						modificateur_val=0
						if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#mpos==nil#", tschan) end
					end
					--si pas de modificateur de type (4d6)+m
					if mpos2==nil and mpos < epos then
						mpos2 = 0
						modificateur_somme_type = "+"
						modificateur_somme_val = 0
						if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#mpos2==nil#", tschan) end
					end 
					if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#mpos#"..mpos.."#", tschan) end
					if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#mpos2#"..mpos2.."#", tschan) end
					if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#mod jet typ val#"..modificateur_type.."#"..modificateur_val.."#", tschan) end
					if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#mod somme typ val#"..modificateur_somme_type.."#"..modificateur_somme_val.."#", tschan) end

					--verification du nombre de face   
					--if epos > dpos and ((epos <= dpos+4 and mpos == 0 )) and (epos >= 4 and mpos == 0) then
					if epos > dpos then
						--recupération du nombre de face
						local face =10
						if mpos == 0 then
							face = tonumber(string.sub(message,dpos+1,epos-1))
						else
							face = tonumber(string.sub(message,dpos+1,mpos-1))
						end
						if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#face#"..face.."#", tschan) end
						if face > 1 then
							--lanceur de dés
							
							local resultat = 0
							local somme = 0
							local fumble = 1
							local sendMsg = ""
							ts3.requestSendChannelTextMsg(serverConnectionHandlerID, "[color=blue]"..fromName.."[/color] "..jet.." [color=red]"..message.."[/color] :", tschan)
							--boucle si plusieurs dés
							if nb_jet > 1 then
								--Vérification si il y a le r
								local rpos = string.find(message,"r")
								local reu = 0
								local nbf = face
								local tabresultat = {}
								local maxtabresultat = 0
								if rpos~=nil then
									 nbf= tonumber(string.sub(message,epos+1,rpos-1))
									if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#nbf#"..nbf.."#", tschan) end
								else
									rpos=0
								end
								--Vérification si il y a le k
								local kpos = string.find(message,"k")
								local keep = 0
								if kpos~=nil then
									keep= tonumber(string.sub(message,math.max(epos,rpos)+1,kpos-1))
								end
								if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#keep#"..keep.."#", tschan) end
                                  --remplissage du tableau de resultat
								if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#nb_jet#"..nb_jet.."#", tschan) end
						        
								for i=1,nb_jet,1 do
									if modificateur_type == "+" then
									math.randomseed (os.time()+i)
									math.random()
									math.random()
									resultat = math.random(face) + modificateur_val
									else
									math.randomseed (os.time()+i)
									math.random()
									math.random()
									resultat = math.random(face) - modificateur_val
									end
									if keep == 0 then
										tabresultat[i]=resultat
										maxtabresultat=maxtabresultat + 1
										
									else
										if maxtabresultat < keep then
											maxtabresultat=maxtabresultat + 1
											tabresultat[maxtabresultat]=resultat
											--ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#maxtabresultat#"..maxtabresultat.."#", tschan)
										else
											for k=1,maxtabresultat,1 do
												if tabresultat[k] < resultat then
												tabresultat[k]=resultat
												k=maxtabresultat
												end 
											end 
										end 
									end
								end
								if debug == 1 then ts3.requestSendChannelTextMsg(serverConnectionHandlerID,"#maxtabresultat#"..maxtabresultat.."#", tschan) end
						         --gestion du resultat
								for i=1,maxtabresultat,1 do
									resultat = tabresultat[i]
									if resultat==fumble then
										sendMsg = sendMsg.."[color=red][b] "..resultat.." [/b][/color] "
									elseif resultat>=nbf then
										sendMsg = sendMsg.."[color=green][b] "..resultat.." [/b][/color] "
									else
										sendMsg = sendMsg.."[b] "..resultat.."[/b] "
									end
									somme = somme + resultat
									if resultat>=nbf then
										reu = reu+1
									end								
								end
						-- gestion du modificateur de somme
								if modificateur_somme_type == "+" then
									somme = somme + modificateur_somme_val
								else
									somme = somme - modificateur_somme_val
								end
								
								ts3.requestSendChannelTextMsg(serverConnectionHandlerID, sendMsg, tschan)
								ts3.requestSendChannelTextMsg(serverConnectionHandlerID, "[color=blue]Total: [b]"..somme.."[/b][/color]", tschan)
								ts3.requestSendChannelTextMsg(serverConnectionHandlerID, "[color=green]Nombre de reussite: [/color][b]"..reu.."[/b]",tschan)
						--cas d'un seul dés (on ne gere pas de total ni de réussite)
							else
								if modificateur_type == "+" then
									math.randomseed (os.time())
									math.random()
									math.random()
									resultat = math.random(face) + modificateur_val
									else
									math.randomseed (os.time())
									math.random()
									math.random()
									resultat = math.random(face) - modificateur_val
								end
								if resultat==fumble then
									sendMsg = sendMsg.."[color=red][b]"..resultat.."[/b][/color]"
								elseif resultat==face then
									sendMsg = sendMsg.."[color=green][b]"..resultat.."[/b][/color]"
								else
									sendMsg = sendMsg.."[b]"..resultat.."[/b]"
								end
								ts3.requestSendChannelTextMsg(serverConnectionHandlerID, sendMsg, tschan)
							end
						end 
					end
				end
			end
		end 
	end	
return 0
end

diceroll_events = {
	onTextMessageEvent = onTextMessageEvent
}
