
declare SAS
SAS = {Dictionary.new}

%=========================================================================
%==============OLD VERSION===========================================
% declare
% proc {BinValueToKeyInSAS Key Val}
%    local CurrentVal in
%       CurrentVal = {Dictionary.get SAS Key}
%       case CurrentVal
%       of equivalence(X) then {Dictionary.put SAS Key Val}
%       else raise alreadyAssigned(Key Val CurrentVal)
% 	   end
%       end
%    end
% end

declare
proc {BindValueToKeyInSAS Key Val}
   if {Dictionary.member SAS Key} then
      case {Dictionary.get SAS Key}
      of equivalence(X) then 
         if X == Key then {Dictionary.put SAS Key Val}
         else {BindValueToKeyInSAS X Val}
         end
      else 
         if {Dictionary.get SAS Key} == Val then skip
         else {Browse failure_trying_to_bound_different_value_to_a_already_bound_variable} raise alreadyAssigned(Key Val {Dictionary.get SAS Key}) end
         end
      end
   else
      {Browse failure_trying_to_bind_to_a_variable_whose_key_is_does_not_exist_in_SAS} {Raise keyDoesNotExist(Key)}
   end
end


declare
proc {BindRefToKeyInSAS Key RefKey}
   {Dictionary.put SAS Key {Dictionary.get SAS RefKey}}
end


declare
fun {RetrieveFromSAS Key}
   {Dictionary.get SAS Key}
end



% ===================================================================
% ======================== Different Version =========================

% declare
% proc {BindValueToKeyInSAS Key Val}
%    if {Dictionary.member SAS Key} then
%       if {Dictionary.get SAS Key} == notBOUND
%       then
%          {Dictionary.put SAS Key Val}
%          % {BindAll equivalence
%       else
%          {Raise alreadyAssigned(Key Val {Dictionary.get SAS Key})}
%       end
%    else
%       {Raise keyDoesNotExist(Key)}
%    end
% end


% declare
% fun {FindRoot Key}
%    local Value in
%       Value = {Dictionary.get SAS Key}
%       case Value of
%          notBOUND then Key
%       [] equivalence(A) then {FindRoot A}
%       else
%          nil
%       end
%    end
% end


% declare
% proc {BindRefToKeyInSAS Key RefKey}
%    if {Dictionary.get SAS Key} == notBOUND
%    then {Dictionary.put SAS Key equivalence({FindRoot RefKey})}
%    else
%       {Raise canNotBound(Key RefKey)}
%    end
% end


% declare
% fun {RetrieveFromSAS Key}
%    if {Dictionary.member SAS Key} then
%       local Value in
%          Value = {Dictionary.get SAS Key}
%          case Value of
%             notBOUND then equivalence(Key)
%          [] equivalence(X) then {RetrieveFromSAS X}
%          []  Y then Y
%          else
%             nil
%          end
%       end
%    else
%       raise missingKey(Key) end
%    end
% end
