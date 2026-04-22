classdef Review_Status < Simulink.IntEnumType
    % Review_Status Enumeration type definition for use with System Composer profile

    enumeration
        Needs_Review(0)
        Under_Review(1)
        Reviewed(2)
    end

end
