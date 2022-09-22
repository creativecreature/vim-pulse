if exists('g:loaded_code_harvest_client')
	finish
endif

let g:loaded_code_harvest_client = 1
let g:code_harvest_session_id = system(["uuidgen"])

function! s:RequireCodeHarvestClient(host) abort
	return jobstart(['code-harvest-client'], {'rpc': v:true})
endfunction

call remote#host#Register('code-harvest-client', 'x', function('s:RequireCodeHarvestClient'))

call remote#host#RegisterPlugin('code-harvest-client', '0', [
			\ {'type': 'function', 'name': 'OnFocusGained', 'sync': 1, 'opts': {}},
			\ {'type': 'function', 'name': 'OpenFile', 'sync': 1, 'opts': {}},
			\ {'type': 'function', 'name': 'SendHeartbeat', 'sync': 1, 'opts': {}},
			\ {'type': 'function', 'name': 'EndSession', 'sync': 1, 'opts': {}},
			\ ])

" We only want track time for one instance nvim instance. We
" need to let the server know which one we have focused.
autocmd FocusGained * :call call("OnFocusGained", [g:code_harvest_session_id, expand('%:p')])

" Let the server know the path of the buffer. Its not a problem to send
" temporary buffers. The server will figure it out and exit early.
autocmd BufEnter * :call call("OpenFile", [g:code_harvest_session_id, expand('%:p')])

" We are sending a heartbeart each time we write a buffer.
" This lets the server know that our session is still active.
autocmd BufWrite * :call call("SendHeartbeat", [g:code_harvest_session_id, expand('%:p')])

" When we exit VIM we inform the server that our coding session has ended.
autocmd VimLeave * :call call("EndSession", [g:code_harvest_session_id])
