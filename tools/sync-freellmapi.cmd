@echo off
setlocal
REM Sync local branches with upstream in one shot:
REM   main      <- merge upstream/main (fork chore commits stay on top)
REM   wip-local <- merge main (personal features: multi-key rotation pool, ...)
REM Stops on any conflict so nothing is half-merged.

cd /d "%~dp0.."

git diff --quiet || (echo Working tree is dirty - commit or stash first. & exit /b 1)

echo Fetching upstream...
git fetch upstream || exit /b 1

echo Updating main...
git checkout main || exit /b 1
git merge upstream/main --no-edit || (echo MERGE CONFLICT on main - resolve manually. & exit /b 1)

echo Updating wip-local...
git checkout wip-local || exit /b 1
git merge main --no-edit || (echo MERGE CONFLICT on wip-local - resolve manually. & exit /b 1)

echo.
echo Done. HEAD is on wip-local (main + personal features).
echo Rebuild/restart via tools\restart-freellmapi.cmd if the server is running.
exit /b 0
