%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% WRITE MODEL OUTPUT TO FILES

% function based on TIME_write_to_file by W. Van Pelt. 
% adapted t fit here jan 2022. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [par,OUTFILE] = TIME_write_to_file(OUTFILE,par,OUT,grid,t,time)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Specify variables to be written
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if t==1
    par.output_times = [];
    OUTFILE.varsout = cell(1,4);
    OUTFILE.varsout(1,:)     = {'melt'           ;'mm'   ;'sum'      ;'Subglacial Melt'};
    OUTFILE.varsout(end+1,:) = {'TB'            ;'K'        ;'mean'       ;'basal shear stress'};
    OUTFILE.varsout(end+1,:) = {'velocity'             ;'m^{day}'    ;'mean'     ;'ice velocity'};
        
    par.varsout = struct('varname',{OUTFILE.varsout{1:end,1}},...
        'units',{OUTFILE.varsout{1:end,2}},'type',{OUTFILE.varsout{1:end,3}},...
        'description',{OUTFILE.varsout{1:end,4}});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Update OUTFILE.TEMP with variables to be stored
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fn = OUTFILE.varsout;
par.freqout = 1 ; 
for i=1:length(fn(:,1))
    temp_long = OUT.(fn{i,1});
    if mod(t-1,par.freqout)==0
        OUTFILE.TEMP.(fn{i,1}) = zeros(size(temp_long));
    end
    if strcmp(fn{i,3},'sample')
        if mod(t+floor(par.freqout/2),par.freqout)==0
            OUTFILE.TEMP.(fn{i,1}) = temp_long';
        end
    elseif strcmp(fn{i,3},'mean')
        OUTFILE.TEMP.(fn{i,1}) = OUTFILE.TEMP.(fn{i,1}) + temp_long/par.freqout;
    elseif strcmp(fn{i,3},'sum')
        OUTFILE.TEMP.(fn{i,1}) = OUTFILE.TEMP.(fn{i,1}) + temp_long;
    end
end
if mod(t-1,par.freqout)==0
    OUTFILE.output_time = time.TCUR/par.freqout;
else
    OUTFILE.output_time = OUTFILE.output_time + time.TCUR/par.freqout;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Save output to binary files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if t==1 
    if ~exist(par.outdir, 'dir')
       mkdir(par.outdir)
    end
    for i=1:length(fn(:,1))
        par.fid(i) = fopen([par.outdir 'OUT_' fn{i,1} '.bin'], 'w');
    end
end

if mod(t,par.freqout)==0
    for i=1:length(fn(:,1))
        OUTFILE.(fn{i,1}) = OUTFILE.TEMP.(fn{i,1});
        fwrite(par.fid(i),OUTFILE.(fn{i,1}),'real*4');
    end
    par.output_times(end+1,1:6) = datevec(OUTFILE.output_time);
end

if t==time.tn
    for i=1:length(fn(:,1))
        fclose(par.fid(i));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Save run info to runinfo.mat in the output directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if t==time.tn
    par.output_times = datetime(par.output_times);
    runinfo.grid = grid;
    runinfo.time = time;
    runinfo.IOout = par;
    runinfo.Cout = par;
    save([par.outdir 'runinfo.mat'],'-struct','runinfo');
end

end
