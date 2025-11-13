classdef RepGenMethods < handle
    %REPGENCLASSES Contains lists of API to be used to fetch data with the
    %purpose of report generator
    %   RepGenH = RepGenClasses() creates a RepGenClass which instantiate
    %   the report generator type. The users can then call the different
    %   type of functions to extract the needed information to be then
    %   appended in the needed order to the report generation
    %
    %
    % RepGenClasses properties:
    %
    %     None
    %
    %
    % RepGenClasses Methods:
    %
    %    - AddTitleAndTOCSection      - add title and toc sections
    %    - AddParagraph              - add paragraph
    %    - AddSection                 - add section containing textual info
    %                                   only
    %    - AddModelSection            - add section for ZC model including
    %                                   component breakdown given a ZQ query as optional
    %    - AddAllocationSection       - add allocation section given an
    %                                   allocation file
    %    - AddViewsSection            - add views section given a model
    %    - AddSequenceDiagramSection  - add sequence diagram section given
    %                                   a list of sequence diagram name and
    %                                   header name 
    %    - AddRequirementSection      - add requirement section given a set
    %    - AddRequirementLinkSection  - add requirement link section given a linkset  
    %    - AddInterfaceChapter        - add interface chapter given a model
    %    - AddProfilesChapter         - add profile chapter given a model
    %    - mustBeChapterOrSection     - input validation function to check if
    %                                   input is section or chapter
    %    - mustbeTrueOrFalse          - input validation function to check
    %                                   is input is true or false
    %    - mustbeZCQuery              - input validation function to check
    %                                   is input is valid ZC query
    %    - mustbeZCModel              - input validation function to check
    %                                   is input is valid ZC model
    %    - mustbeAllocationSet        - input validation function to check
    %                                   is input is an allocation file
    %    - mustBeReqSet               - input validation function to check
    %                                   is input is a reqset
    %    - mustBeDescOrModelNotes     - input validation function to check
    %                                   is input description or model notes

    methods
        %% Instantiation function
        function obj = RepGenMethods()
            % nothing to do it is just an intance
        end
          

        %% Businnes Logic Functions        
        
        %% Function to insert the title, author, location and table
        % of contenct
        %
        % Inputs:
        %       title  - tile of the report
        %       author - author of the report
        %       options.date   - issue of the report
        %       options.issue  - issue of the report
        % Outputs:
        %       sec_handle_title - section title of the report
        %       sec_handle_toc   - table of contents

        function [sec_handle_title,sec_handle_toc] = AddTitleAndTOCSection(obj,title,author,options)
            % Input arguments validation
            arguments
                obj
                title {mustBeText}
                author {mustBeText}
                options.date {datetime} = datetime("today")
                options.issue {mustBeText} = "1.0"
            end

            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*

            % define front page data
            sec_handle_title = TitlePage;
            sec_handle_title.Title = upper(title);
            sec_handle_title.Author = author;
            sec_handle_title.PubDate = string(options.date) + " - Ver. " +  options.issue;

            % define toc
            sec_handle_toc = TableOfContents;

        end
        
        %% Function to add a given text into separate section
        %
        % Inputs:
        %       title  - tile of the paragraph
        %       text   - text of the paragraph
        %       parent - handle to the parent section
        % Outputs:
        %       sec_handle               - report section
               
        function sec_handle = AddSection(obj,title,text)
            % Input arguments validation
            arguments
                obj
                title {mustBeText}
                text {mustBeText}
            end

            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*


            % Instantiate a paragraph and append it to the parent section
            sec_handle = Section('Title', title);
            append(sec_handle, Paragraph(text));
        end
        
        
        %% Function to add a given paragraph
        %
        % Inputs:
        %       title  - tile of the paragraph
        %       text   - text of the paragraph
        %       parent - handle to the parent section
        % Outputs:
               
        function AddParagraph(obj,title,text,parent)
            % Input arguments validation
            arguments
                obj
                title {mustBeText}
                text {mustBeText}
                parent {mustBeChapterOrSection(obj,parent)}
            end

            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*


            % Instantiate a paragraph and append it to the parent section
            sec = Section('Title', title);
            p = Paragraph(text);
            append(sec, p);
            append(parent,sec);
        end

        %% Function to add the section given a ZC model
        %
        % Inputs:
        %       SectionName              - name of the section
        %       modelH                   - system composer model handle, loaded via the
        %                                  systemcomposer.systemcomposer.loadModel
        %       options.AllocationFile   - name of the allocation file;
        %                                  default is empty
        %       options.InsertAllocation - flag to include or not the
        %                                  allocation for each component in context; default is false
        %       options.ZC_Query         - system composer query to exclude
        %                                  certain components from the report; default all components are in
        %       options.descSrc          - string to define where to take
        %                                  description can be either "description" (default value) or "notes" (the model notes)
        %                                  if description is empty nothing
        %                                  will be rendered
        %       options.paragraphtxt     - optional paragraph text
        % Outputs:
        %       sec_handle               - report section

        function sec_handle = AddModelSection(obj,SectionName,modelH,options)
            % Input arguments validation
            arguments
                obj %#ok<*INUSA> 
                SectionName {mustBeText}
                modelH {mustbeZCModel(obj,modelH)}
                options.ZC_Query {mustbeZCQuery(obj,options.ZC_Query)} = "AnyComponent();"
                options.descSrc {mustBeDescOrModelNotes(obj,options.descSrc)} = "None"
                options.paragraphtxt {mustBeText} = ""
            end

            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*


            % Insantiate the section handle
            sec_handle = Section("Title",SectionName);

            % Add paragraph if not empty
            if ~strcmp(options.paragraphtxt,"")
                append(sec_handle, Paragraph(options.paragraphtxt));
            end

            % Fork based on the source of the description extract
            % description or model notes if not empty
            if strcmp(options.descSrc,"Description")
                % Extract and add the description (if not empty)
                if ~isempty(get_param(modelH.Name,'Description'))
                    append(sec_handle,get_param(modelH.Name,'Description'));
                end
            elseif strcmp(options.descSrc,"Model Notes")
                % Extract mdoel notes
                append(sec_handle,Notes(modelH.Name));
            end

            % Adding snapshot of the model
            systemContext = Section(modelH.Name);
            finder = SystemDiagramFinder(modelH.Name);
            finder.SearchDepth = 0;
            results = find(finder);
            append(systemContext, results);
            append(sec_handle, systemContext);

            % Use the ComponentFinder to find all components in the model
            cf = ComponentFinder(modelH.Name);
            cf.Query = eval(options.ZC_Query);
            comp_finder = find(cf);

            % For each component define a section that includes the description of
            % the component (if not empty) and the allocation if the
            % InsertAllocation flag is enabled
            for comp = comp_finder

                % Append the section
                componentSection = Section("Title", comp.Name);
                
                % Fork based on the source of the description extract
                % description or model notes if not empty
                if strcmp(options.descSrc,"Description")
                    % Extract and add the description (if not empty)
                    if ~isempty(get_param(getfullname(lookup(modelH,'UUID',comp.Object).SimulinkHandle),'Description'))
                        append(componentSection,get_param(getfullname(lookup(modelH,'UUID',comp.Object).SimulinkHandle),'Description'));
                    end
                elseif strcmp(options.descSrc,"Model Notes")
                    % Extract mdoel notes
                    append(componentSection,Notes(getfullname(lookup(modelH,'UUID',comp.Object).SimulinkHandle)));
                end

                % Append the component to the section
                append(componentSection, comp);

                % Append component Information
                append(systemContext, componentSection);
            end
        end
        
        %% Function to add the allocation section given an allocation file
        %
        % Inputs:
        %       SectionName              - name of the section
        %       AllocationFile           - name of the allocation file
        %       options.paragraphtxt     - optional paragraph text
        %
        % Outputs:
        %       sec_handle               - report section

        function sec_handle = AddAllocationSection(obj,SectionName,AllocationFile,options)
            % Input argument validation
            arguments
                obj
                SectionName {mustBeText}
                AllocationFile {mustbeAllocationSet(obj,AllocationFile)}
                options.paragraphtxt {mustBeText} = ""
            end

            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*

            % Instantiate the section
            sec_handle = Section("Title",SectionName);

            % Add paragraph if not empty
            if ~strcmp(options.paragraphtxt,"")
                append(sec_handle, Paragraph(options.paragraphtxt));
            end

            % Extract data fom the allocaiton file and render these as table
            allocation_finder = AllocationSetFinder(AllocationFile);
            while hasNext(allocation_finder)
                alloc = next(allocation_finder);
                allocationName = Section(alloc.Name);
                append(allocationName, alloc);
                append(sec_handle, allocationName);
            end
        end

        %% Function to add views sections given a ZC model
        %
        % Inputs:
        %       SectionName              - name of the section
        %       modelH                   - system composer model handle, loaded via the
        %                                  systemcomposer.systemcomposer.loadModel
        %       options.paragraphtxt     - optional paragraph text
        %
        % Outputs:
        %       sec_handle               - report section

        function sec_handle = AddViewsSection(obj,SectionName,modelH,options)
            % Input arguments validation
            arguments
                obj
                SectionName {mustBeText}
                modelH {mustbeZCModel(obj,modelH)}
                options.paragraphtxt {mustBeText} = ""
            end

            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*

            % Instantiate the section
            sec_handle = Section("Title",SectionName);

            % Add paragraph if not empty
            if ~strcmp(options.paragraphtxt,"")
                append(sec_handle, Paragraph(options.paragraphtxt));
            end

            % Check if model has views and fetch them, else print an empty
            % paragraph
            if isempty(modelH.Views)
                append(sec_handle, Paragraph("No views are defined for the considered model"));
            else    
                % Ectract all the views belonging to the model and append these
                % nto into the views chapter
                view_finder = ViewFinder(modelH.Name);
                while(hasNext(view_finder))
                    v = next(view_finder);
                    viewName = Section('Title', v.Name);
                    append(viewName, v);
                    append(sec_handle, viewName);
                end
            end
        end

        %% Function to add sequence diagram sections given a ZC model and list of diagram to be rendered
        %
        % Inputs:
        %       SectionName              - name of the section
        %       modelH                   - system composer model handle, loaded via the
        %                                  systemcomposer.systemcomposer.loadModel
        %       SqList                   - list of sequence diagram to be
        %                                  exported and associated names to be given
        %       options.paragraphtxt     - optional paragraph text
        %
        % Outputs:
        %       sec_handle               - report section

        function sec_handle = AddSequenceDiagramSection(obj,SectionName,modelH,SqList,options)
            % Input arguments validation
            arguments
                obj
                SectionName {mustBeText}
                modelH {mustbeZCModel(obj,modelH)}
                SqList {mustBeNonempty}
                options.paragraphtxt {mustBeText} = ""
            end

            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*

            % Instantiate the section
            sec_handle = Section('Title',SectionName);

            % Add paragraph if not empty
            if ~strcmp(options.paragraphtxt,"")
                append(sec_handle, Paragraph(options.paragraphtxt));
            end

            % Loop through the list of sequence diagram to be printed.
            % Fetch these, create a secion and happend everything below the
            % main section
            for  i = 1:size(SqList,1)
                % Create a section that holds the diagram
                sec = Section('Title', SqList{i,2});
                
                % Fetch and append the diagram to the section
                sd = systemcomposer.rptgen.report.SequenceDiagram("Name",SqList{i,1},"ModelName",modelH.Name);
                append(sec,sd)
                
                % Happend to the main section
                append(sec_handle,sec);
            end
        end
        
        %% Function to add requirements given req set
        %
        % Inputs:
        %       paragraphtxt             - text of the paragraph to be
        %                                  added before the requirement collection
        %       reqSet                   - rewuirement set file
        %       options.UseCaseType      - option to render the
        %                                  requirements as use case diagram
        %
        % Outputs:
        %       sec_handle               - report section

        function sec_handle = AddRequirementSection(obj,SectionName,paragraphtxt,reqSet,options)
            % Input arguments validation
            arguments
                obj
                SectionName {mustBeText}
                paragraphtxt {mustBeText}
                reqSet {mustBeReqSet(obj,reqSet)}
                options.UseCaseType {mustBeText} = "Classical"
            end
            
            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*


            % Define main section name
            sec_handle = Section("Title",SectionName);

            % Etract all the requirement in the given requirement set and
            % render these. Fork to render the requirements in a classical
            % tabular format or as a use case report
            if strcmpi(options.UseCaseType,"classical")
                reqFinder = RequirementSetFinder(reqSet);
                result = find(reqFinder);
                pp = Paragraph(paragraphtxt);
                append(sec_handle, pp);
                append(sec_handle, result.getReporter);
            elseif strcmpi(options.UseCaseType,"usecase") 
                ReqSet = slreq.load(reqSet);
                reqs = ReqSet.children;
                for req = reqs
                    subsec = Section('Title', req.Summary);
                    p = HTML(strrep(req.Description,'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">',''));
                    append(subsec, p);
                    p = Paragraph('HERE GOES THE TRACEABILITY DIAGRAM');
                    append(subsec, p);
                    append(sec_handle,subsec)
                end
            end
        end
        
        %% Function to add requirement link section for given requirement linkset
        %
        % Inputs:
        %       SectionName              - name of the section
        %       modelH                   - system composer model handle, loaded via the
        %                                  systemcomposer.systemcomposer.loadModel
        %       options.paragraphtxt     - optional paragraph text
        %
        % Outputs:
        %       sec_handle               - report section

        function sec_handle = AddRequirementLinkSection(obj,SectionName,modelH,options)
            % Input arguments validation
            arguments
                obj
                SectionName {mustBeText}
                modelH {mustbeZCModel(obj,modelH)}
                options.paragraphtxt {mustBeText} = ""
            end

            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*

            % Define main section name
            sec_handle = Section("Title",SectionName);

            % Add paragraph if not empty
            if ~strcmp(options.paragraphtxt,"")
                append(sec_handle, Paragraph(options.paragraphtxt));
            end

            % Get the pointer to the linkset if existit, else print a
            % paragraph saying that no linkset exist for the given model
            try
                reqlinkset = slreq.load(modelH.Name);
                % Etract all the requirement link in the given requirement link set and
                % render these
                reqLinkFinder = RequirementLinkFinder(reqlinkset.Filename);
                resultL = find(reqLinkFinder);
                rptr = systemcomposer.rptgen.report.RequirementLink("Source", resultL);
                append(sec_handle, rptr);
            
            catch
                 append(sec_handle, Paragraph("No linkset are defined for the considered model"));
            end            
        end

        %% Function to add interfaces appendinx for given model
        %
        % Inputs:
        %       SectionName              - name of the section
        %       modelH                   - system composer model handle, loaded via the
        %                                  systemcomposer.systemcomposer.loadModel
        %       options.paragraphtxt     - optional paragraph text
        %
        % Outputs:
        %       sec_handle               - report section

        function sec_handle = AddInterfaceChapter(obj,SectionName,modelH,options)
            % Input arguments validation
            arguments
                obj
                SectionName {mustBeText}
                modelH {mustbeZCModel(obj,modelH)}
                options.paragraphtxt {mustBeText} = ""
            end

            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*


            % Instantiate appendix name
            sec_handle = Section("Title","Interfaces Appendix - " + SectionName);

            % Add paragraph if not empty
            if ~strcmp(options.paragraphtxt,"")
                append(sec_handle, Paragraph(options.paragraphtxt));
            end
            
            % Check if model has a dictionary associated with if so parse
            % the interface, else put a paragrpah to say interfaces are not
            % defined
            if isempty(modelH.InterfaceDictionary.Interfaces)
                append(sec_handle, Paragraph("No interfaces are defined for the considered model"));
            else
                interfaceFinder = InterfaceFinder(modelH.Name);
                interfaceFinder.SearchIn = "Model";
                while hasNext(interfaceFinder)
                    intf = next(interfaceFinder);
                    interfaceName = Section(intf.InterfaceName);
                    append(interfaceName, intf);
                    append(sec_handle, interfaceName);
                end
            end
        end

        %% function to add profile definition given model name
        %
        % Inputs:
        %       SectionName              - name of the section
        %       modelH                   - system composer model handle, loaded via the
        %                                  systemcomposer.systemcomposer.loadModel
        %       options.paragraphtxt     - optional paragraph text
        %
        % Outputs:
        %       sec_handle               - report section

        function sec_handle = AddProfilesChapter(obj,SectionName,modelH,options)
            % Input arguments validation
            arguments
                obj
                SectionName {mustBeText}
                modelH {mustbeZCModel(obj,modelH)}
                options.paragraphtxt {mustBeText} = ""
            end

            %Import the needed libriaries
            import mlreportgen.report.*
            import slreportgen.report.*
            import slreportgen.finder.*
            import mlreportgen.dom.*
            import mlreportgen.utils.*
            import systemcomposer.query.*
            import systemcomposer.rptgen.finder.*


            % Instantate appendix name
            sec_handle = Section("Title","Profile Appendix - " + SectionName);

            % Add paragraph if not empty
            if ~strcmp(options.paragraphtxt,"")
                append(sec_handle, Paragraph(options.paragraphtxt));
            end
            
            % Check if model has profiles and fetch them, else print an empty
            % paragraph
            if isempty(modelH.Profiles)
                append(sec_handle, Paragraph("No profiles are defined for the considered model"));
            else   
                        
                % Loop through all the associated profiles, extract needed
                % data and append into a section
                for profile = modelH.Profiles
                    ProfileSection = Section("Profiles - " + profile.Name);
                    pf = ProfileFinder(profile.Name);
                    while hasNext(pf)
                        intf = next(pf);
                        profileName = Section(intf.Name);
                        append(profileName, intf);
                        append(ProfileSection, profileName);
                    end
                    
                    StereotypeSection = Section("Profiles - " + profile.Name);
                    sf = StereotypeFinder(profile.Name);
                    while hasNext(sf)
                        stf = next(sf);
                        stereotypeName = Section(stf.Name);
                        append(stereotypeName, stf);
                        append(StereotypeSection, stereotypeName);
                    end
                    append(ProfileSection, StereotypeSection);
                end
                append(sec_handle, ProfileSection);
            end
        end
       
        %% Input Validation Functions
        
        % Test for mustbe chapter or section
        function mustBeChapterOrSection(~,input)
            if ~isa(input,'mlreportgen.report.Section')
                eid = 'Input:NotAChapterOrSection';
                msg = 'Parent handler it nor a chapter neither a section"';
                throwAsCaller(MException(eid,msg))
            end
        end
        
        % Test for mustbe true or false
        function mustbeTrueOrFalse(~,input)
            if ~(strcmp(input,"false") || strcmp(input,"true"))
                eid = 'Input:NotAllowedValue';
                msg = 'Allowed inputs for this variable can only be "true" or "false"';
                throwAsCaller(MException(eid,msg))
            end
        end

        % Test for being valid query
        function mustbeZCQuery(~,query)
            import systemcomposer.query.*
            try
                eval(query);  
            catch
                eid = 'Input:InvalidQuery';
                msg = 'Defined query is not a valid system composer query';
                throwAsCaller(MException(eid,msg))
            end
        end

        % Test for begin a ZC model
        function mustbeZCModel(~,mdl)
            if ~isa(mdl,'systemcomposer.arch.Model')
                eid = 'Input:InvalidModelType';
                msg = 'The model is not a valid system composer model';
                throwAsCaller(MException(eid,msg))
            end
        end

        % Test for being valid allocation set    
        function mustbeAllocationSet(~,file)
            try
                systemcomposer.allocation.load(file);
            catch
                eid = 'Input:InvalidAllocationSet';
                msg = 'Defined file is not a valid system composer allocation set';
                throwAsCaller(MException(eid,msg))
            end
        end

        % Test for being a requirement set
        function mustBeReqSet(~,input)
            if ~isa(slreq.load(input),'slreq.ReqSet')
                eid = 'Input:InvalidAReqSet';
                msg = 'The file is not a valid requirement set';
                throwAsCaller(MException(eid,msg))
            end
        end
        
        % Test for source of the descriptiion being either the description
        % or the model notes
        function mustBeDescOrModelNotes(~,input)
            if ~(strcmpi(input,"Description") || strcmp(input,"Model Notes") || strcmp(input,"None"))
                eid = 'Input:NotAllowedValue';
                msg = 'Allowed inputs for this variable can only be "None", "Description" or "Model Notes"';
                throwAsCaller(MException(eid,msg))
            end
        end

        % Test for being a requirement link set
        function mustBeReqLinkSet(~,input)
            if ~isa(slreq.load(input),'slreq.LinkSet')
                eid = 'Input:InvalidAReqLinkSet';
                msg = 'The file is not a valid requirement link set';
                throwAsCaller(MException(eid,msg))
            end
        end
    end
end