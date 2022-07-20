function LoadCantera
    if ispc
        ctname = 'cantera_shared.dll';
    elseif ismac
        ctname = 'libcantera_shared.dylib';
    elseif isunix
        ctname = 'libcantera_shared.so';  
    else
        error('Operating System Not Supported!');
        return;
    end
    if ~libisloaded(ct)
        [~,warnings] = loadlibrary([cantera_root '/Lib/' ctname], ...
                                   [cantera_root '/include/cantera/clib/ctmatlab.h'], ...
                                   'includepath', [cantera_root '/include'], ...
                                   'addheader','ct','addheader','ctfunc', ...
                                   'addheader','ctmultiphase','addheader', ...
                                   'ctonedim','addheader','ctreactor', ...
                                   'addheader','ctrpath','addheader','ctsurf');
    end
    disp('Cantera is ready for use');
end
