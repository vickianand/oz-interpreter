\insert 'Unify_new.oz'
%\insert 'Programs.oz'

% we will use S_stack() procedure as the semantic stack.
% it will have two arguments namely, S_stmnt and Env;
% S_state represents the semantic statement and Env represents semantic environment



% UniKey is a cell used for assigning key to the variables in the Environment and SAS.


%declare Env = {Dictionary.new}

 
% RetKey() function is used for getting a key corresponding to some value from the list of a Dictionary entries
% Ls : list of dictionary entries, X : value whose key we are looking for

declare RetKey
fun {RetKey Ls X}
   case Ls
   of nil then nil
   [] L|Lr then
      case L
      of A#B then if B == X then A else {RetKey Lr X} end
      end
   end
end


declare
fun {ReplaceFeatures Rec Env}
	local Help ReplacedList in
		fun {Help Ls}
			case Ls
			of nil then nil
			[] X|Xr then 
				case X.1 of ident(Y) then 
					[{RetrieveFromSAS {Dictionary.get Env Y}} X.2.1] | {Help Xr}
				else X|{Help Xr}
				end 
			end
		end
		ReplacedList = {Help Rec.2.2.1}
		case Rec.2.1
		of ident(Z) then
			[record {RetrieveFromSAS {Dictionary.get Env Z}} ReplacedList]
		else [record Rec.2.1 ReplacedList]
		end
	end
end



declare UniKey = {NewCell 1} %initially we will keep it as 0 and increment in every subsequent assignment



declare
proc {BindMatching LSAS LInp Env2}
   %{Browse inside_bind_matching} {Browse LSAS} {Browse LInp} {Browse outside_bind_matching_function}
   case LSAS#LInp
   of (X|Xr)#(Y|Yr) then %{Browse X} {Browse Y.2.1.1}
      {Dictionary.remove Env2 Y.2.1.1}
      {Dictionary.put Env2 Y.2.1.1 @UniKey} %{Browse new_var_added_to_env_inside_bind_matching_function} {Browse {Dictionary.entries Env2}}
      {Dictionary.put SAS @UniKey equivalence(@UniKey)}
      UniKey := @UniKey + 1 {Browse browsing_before_unify_in_Bind_matching} {Browse Y.2.1} {Browse X.2.1} {Browse {Dictionary.entries SAS}}
      {Unify Y.2.1 X.2.1 Env2} {Browse browsing_after_unify_in_Bind_matching} {Browse Y.2.1} {Browse X.2.1}
      {BindMatching Xr Yr Env2}
   [] nil#nil then skip
   else
      raise bind_matching_error end
   end
end




declare
proc {S_stack S_stmnt Env}
   case S_stmnt
   of nil then skip
   [] X|Xr then


      if X == nop then
	 skip
	 {Browse skipping}  % comment out this line in final code
	 {S_stack Xr Env}


      elseif X == localvar then	% {Browse Xr.1.1}
		 {Dictionary.remove Env Xr.1.1}
		 {Dictionary.put Env Xr.1.1 @UniKey}
		 {Dictionary.put SAS @UniKey equivalence(@UniKey)}% {Dictionary.put SAS @UniKey notBOUND} => this one to be used with old version of SAS implementation
		 UniKey := @UniKey + 1
		 {Browse added_something_to_Env} {Browse Xr.1.1} {Browse {Dictionary.entries Env}} {Browse above_is_the_new_Env}
		 local Env2 in
		    Env2 = {Dictionary.clone Env}
		    {S_stack Xr.2 Env2}  % equivalent to <s>
		 end
		 {Browse {Dictionary.entries Env}}  % comment out this line in final code
		 {Dictionary.remove Env Xr.1.1}  % equivalent to end



      elseif X == bind then {Browse i_am_in_bind_block} {Browse {Dictionary.entries Env}}
      	if Xr.2.1.1 == procedure then {Unify Xr.1 procedure(Xr.2.1 {Dictionary.clone Env}) Env} %{Browse procedure_to_be_bounddddddddddd}
	 	else {Browse {Dictionary.entries SAS}} {Browse {Dictionary.entries Env}} {Browse Xr.1} {Browse Xr.2.1}
	 	{Unify Xr.1 Xr.2.1 Env}
	 	end
	 	{Browse {Dictionary.entries SAS}}  % comment out this line in final code



      elseif X == conditional then
		 %%{Browse in_conditional_block} {Browse Xr.1} {Browse {Dictionary.entries Env}} {Browse {Dictionary.get Env Xr.1.1}} {Browse {RetrieveFromSAS {Dictionary.get Env Xr.1.1}}}
		 
		 %if {RetrieveFromSAS {Dictionary.get Env Xr.1.1}} == bool(yes)
		 %then {S_stack Xr.2.1 Env}
		 %elseif {RetrieveFromSAS {Dictionary.get Env Xr.1.1}} == bool(no)
		 %then {S_stack Xr.2.2.1 Env}
		 %else {Browse suspending_from_conditional_block} raise suspension_from_conditonal
		 %end

		 case {RetrieveFromSAS {Dictionary.get Env Xr.1.1}}
		 	of bool(A) then 
		 		if A == yes then {S_stack Xr.2.1 Env}
		 		elseif A == no then {S_stack Xr.2.2.1 Env}
		 		end
		 	else {Browse suspending_from_conditional_block} raise suspension_from_conditonal end
		 end





      elseif X == match then
		 local RecSAS RecInp Env2 BindValues in
		    RecSAS = {RetrieveFromSAS {Dictionary.get Env Xr.1.1}}
		    %{Browse debugging_match} {Browse RecSAS} {Browse Xr.2.1}
		    if {And RecSAS.1 == record Xr.2.1.1 == record} then %{Browse both_are_records_in_match}
		       RecInp = {ReplaceFeatures Xr.2.1 Env}
		       if {And RecInp.2.1 == RecSAS.2.1 {MatchRecords {Canonize RecSAS.2.2.1} {Canonize RecInp.2.2.1} Env} } then {Browse both_records_are_matching}
			  Env2 = {Dictionary.clone Env}
			  {BindMatching {Canonize RecSAS.2.2.1} {Canonize RecInp.2.2.1} Env2}
			  {S_stack Xr.2.2.1 Env2}  % equivalent to inner <s> to stack
			  else {Browse i_am_in_else_of_record_matching} {Browse Xr.2.2.2.1} {S_stack Xr.2.2.2.1 Env}
		       end
		    else {S_stack Xr.2.2.2.1 Env}
		    end
		 end


      elseif X == apply then %{Browse i_am_in_apply_blockkkkkkkkkkkkkk}
      	 local SavedProc Env2 BoundingVars ProcVars BindVars ProcStatement in
      	    SavedProc = {RetrieveFromSAS {Dictionary.get Env Xr.1.1}} %{Browse saved_proc_is} {Browse SavedProc}
      	    Env2 = SavedProc.2 %{Browse saved_Env2_for_proc_is} {Browse {Dictionary.entries Env2}}
      	    ProcVars = SavedProc.1.2.1	 % % [ident(a1) ... ident(an)]
      	    ProcStatement = SavedProc.1.2.2.1 %{Browse proc_statement_is} {Browse ProcStatement}
      	    BoundingVars = Xr.2  % [ident(b1) ... ident(bn)]
      	    proc {BindVars As Bs}
      	       case As#Bs
      	       of (A|Ar)#(B|Br) then
      		  	{Dictionary.remove Env2 A.1}	% A is of form: ident(ai)
      		  	{Dictionary.put Env2 A.1 {Dictionary.get Env B.1}}
		  		{BindVars Ar Br}
	       		else skip
      	       end
	    end
	    %{Browse i_am_about_to_call_BindVars_in_apply_block_presently_Env2_is} {Browse {Dictionary.entries Env2}}
	    %{Browse procVars_are} {Browse ProcVars} {Browse boundingVars_are} {Browse BoundingVars}
	    {BindVars ProcVars BoundingVars} %{Browse env2_after_BindVars_call_in_apply_block_is} {Browse {Dictionary.entries Env2}}
      	    {S_stack ProcStatement Env2}
      	 end

	  	
      else
	 % {Browse S_stmnt}
	 %{Browse putting_onto_stack} {Browse X} {Browse with_env_as} {Browse Env}
	 {S_stack X Env}
	 %{Browse also_putting_onto_stack} {Browse Xr} {Browse with_env_as} {Browse Env}
	 {S_stack Xr Env}
      end
      
   end
end




%declare Temp = {Dictionary.new}
%{S_stack Prog14 Temp}
%{Browse finally_sAS_is}
%{Browse {Dictionary.entries SAS}}



declare
proc {Interpreter Prog}
   local Env in
		Env = {Dictionary.new}
		{S_stack Prog Env}
		%below lines are just for testing that finally Env becomes empty
		{Browse finally_Env_is}
		{Browse {Dictionary.entries Env}}
   end
end
