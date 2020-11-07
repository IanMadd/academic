serve: assets
	hugo server --noHTTPCache --buildFuture

serve_drafts: assets
	hugo server --buildDrafts --noHTTPCache --buildFuture

serve_ignore_vendor: assets
	hugo server --buildDrafts --noHTTPCache --buildFuture --ignoreVendor
